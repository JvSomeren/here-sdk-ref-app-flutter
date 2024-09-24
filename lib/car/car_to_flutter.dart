import 'dart:async';

import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/navigation.dart';

import '../pigeons/car.pg.dart';
import '../positioning/positioning.dart';
import '../positioning/positioning_engine.dart';

abstract interface class CarRoutingListener {
    void stopRouting();
    void updateSelectedRouteOption(int routeOptionIndex);
}

class CarToFlutter extends CarToFlutterApi {
    late final PositioningEngine _positioningEngine;
    StreamSubscription<Location>? _locationUpdatesSubscription;

    CarToFlutter(PositioningEngine positioningEngine) {
        // Register this class instance to receive calls from the platform code.
        CarToFlutterApi.setUp(this);
        _positioningEngine = positioningEngine;
    }

    void dispose() {
        // On disposal we de-register handling of calls.
        CarToFlutterApi.setUp(null);
        _locationUpdatesSubscription?.cancel();
    }

    @override
    void setupMapView() async {
        // Notice that we use the same 'id' as we defined in our platform code.
        final mapController = HereMapController(123);

        final isInitialized = await mapController.initialize((_) {});
        if (!isInitialized) throw 'Failed to initialize HereMapController';

        // Here we load the given MapScheme for the map running on
        // our Android Auto / Apple CarPlay screen.
        mapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay, (error) {
            if (error != null) {
                throw 'Failed loading scene: $error';
            }
            
            // This VisualNavigator will be applied to the Android Auto / Apple CarPlay map.
            final visualNavigator = VisualNavigator()..startRendering(mapController);

            final lastKnownLocation = _positioningEngine.lastKnownLocation;
            if (lastKnownLocation != null) {
                mapController.camera.lookAtPointWithMeasure(
                    lastKnownLocation.coordinates,
                    MapMeasure(MapMeasureKind.distance, Positioning.initDistanceToEarth),
                );

                visualNavigator.onLocationUpdated(lastKnownLocation);
            }
            _locationUpdatesSubscription =
                _positioningEngine.getLocationUpdates.listen((event) {
                    visualNavigator.onLocationUpdated(event);
                });
        });
    }
    
    final Set<CarRoutingListener> _carRoutingListeners = {};

    void addRoutingListener(CarRoutingListener listener) {
        _carRoutingListeners.add(listener);
    }

    void removeRoutingListener(CarRoutingListener listener) {
        _carRoutingListeners.remove(listener);
    }

    @override
    void stopRouting() {
        for (final listener in _carRoutingListeners) {
            listener.stopRouting();
        }
    }

    @override
    void updateSelectedRouteOption(int routeOptionIndex) {
        for (final listener in _carRoutingListeners) {
            listener.updateSelectedRouteOption(routeOptionIndex);
        }
    }

    @override
    void onDisconnect() {
        _locationUpdatesSubscription?.cancel();
    }
}
