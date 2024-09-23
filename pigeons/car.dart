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

// Declare an API to call from our platform code into our Flutter code.
@FlutterApi()
abstract class CarToFlutterApi {
    void setupMapView();
}
