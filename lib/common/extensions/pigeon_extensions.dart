import 'package:flutter/material.dart' show BuildContext;
import 'package:here_sdk/core.dart';
import 'package:here_sdk/routing.dart';

import '../../pigeons/car.pg.dart';
import '../util.dart' as Util;

extension RoutePigeonUtil on Route {
    PgRouteOption toPgRouteOption(BuildContext context) => PgRouteOption(
                hashCode: hashCode,
                lengthInMeters: lengthInMeters,
                durationInSeconds: duration.inSeconds,
                distanceString: Util.makeDistanceString(context, lengthInMeters),
                durationString: Util.makeDurationString(context, duration.inSeconds),
            );
}

extension GeoCoordinatesPigeonUtil on GeoCoordinates {
    PgLatLng toPgLatLng() => PgLatLng(latitude: latitude, longitude: longitude);
}
