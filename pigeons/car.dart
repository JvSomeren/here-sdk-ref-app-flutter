import 'package:pigeon/pigeon.dart';

// Configure where our generated pigeon code should end up.
@ConfigurePigeon(PigeonOptions(
    input: 'pigeons/car.dart',
    // Flutter
    dartOut: 'lib/pigeons/car.pg.dart',
    // Android
    kotlinOut: 'android/app/src/main/kotlin/com/example/RefApp/Car.pg.kt',
    kotlinOptions: KotlinOptions(package: 'com.example.RefApp'),
    // iOS
    swiftOut: 'ios/Runner/Car.pg.swift',
))

class PgRouteOption {
    final int hashCode;

    final int lengthInMeters;

    final int durationInSeconds;

    final String distanceString;

    final String durationString;

    const PgRouteOption({
        required this.hashCode,
        required this.lengthInMeters,
        required this.durationInSeconds,
        required this.distanceString,
        required this.durationString,
    });
}

class PgLatLng {
    final double latitude;
    final double longitude;

    const PgLatLng(this.latitude, this.longitude);
}

class PgRouteOptionsUpdatedMessage {
    final PgLatLng origin;
    final PgLatLng destination;
    final List<PgRouteOption?> routeOptions;

    const PgRouteOptionsUpdatedMessage({
        required this.origin,
        required this.destination,
        required this.routeOptions,
    });
}

@FlutterApi()
abstract class CarToFlutterApi {
    void setupMapView();

    void updateSelectedRouteOption(int routeOptionIndex);

    void stopRouting();

    void onDisconnect();
}

@HostApi()
abstract class FlutterToCarApi {
    void onStartRouting();

    void onRouteOptionsUpdated(PgRouteOptionsUpdatedMessage message);

    void onRouteOptionSelected(int routeOptionIndex);

    void onStopRouting();
}
