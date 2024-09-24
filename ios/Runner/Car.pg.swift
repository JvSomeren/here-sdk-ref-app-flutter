// Autogenerated from Pigeon (v22.4.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation

#if os(iOS)
  import Flutter
#elseif os(macOS)
  import FlutterMacOS
#else
  #error("Unsupported platform.")
#endif

/// Error class for passing custom error details to Dart side.
final class PigeonError: Error {
  let code: String
  let message: String?
  let details: Any?

  init(code: String, message: String?, details: Any?) {
    self.code = code
    self.message = message
    self.details = details
  }

  var localizedDescription: String {
    return
      "PigeonError(code: \(code), message: \(message ?? "<nil>"), details: \(details ?? "<nil>")"
      }
}

private func wrapResult(_ result: Any?) -> [Any?] {
  return [result]
}

private func wrapError(_ error: Any) -> [Any?] {
  if let pigeonError = error as? PigeonError {
    return [
      pigeonError.code,
      pigeonError.message,
      pigeonError.details,
    ]
  }
  if let flutterError = error as? FlutterError {
    return [
      flutterError.code,
      flutterError.message,
      flutterError.details,
    ]
  }
  return [
    "\(error)",
    "\(type(of: error))",
    "Stacktrace: \(Thread.callStackSymbols)",
  ]
}

private func createConnectionError(withChannelName channelName: String) -> PigeonError {
  return PigeonError(code: "channel-error", message: "Unable to establish connection on channel: '\(channelName)'.", details: "")
}

private func isNullish(_ value: Any?) -> Bool {
  return value is NSNull || value == nil
}

private func nilOrValue<T>(_ value: Any?) -> T? {
  if value is NSNull { return nil }
  return value as! T?
}

/// Generated class from Pigeon that represents data sent in messages.
struct PgRouteOption {
  var hashCode: Int64
  var lengthInMeters: Int64
  var durationInSeconds: Int64
  var distanceString: String
  var durationString: String



  // swift-format-ignore: AlwaysUseLowerCamelCase
  static func fromList(_ pigeonVar_list: [Any?]) -> PgRouteOption? {
    let hashCode = pigeonVar_list[0] as! Int64
    let lengthInMeters = pigeonVar_list[1] as! Int64
    let durationInSeconds = pigeonVar_list[2] as! Int64
    let distanceString = pigeonVar_list[3] as! String
    let durationString = pigeonVar_list[4] as! String

    return PgRouteOption(
      hashCode: hashCode,
      lengthInMeters: lengthInMeters,
      durationInSeconds: durationInSeconds,
      distanceString: distanceString,
      durationString: durationString
    )
  }
  func toList() -> [Any?] {
    return [
      hashCode,
      lengthInMeters,
      durationInSeconds,
      distanceString,
      durationString,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct PgLatLng {
  var latitude: Double
  var longitude: Double



  // swift-format-ignore: AlwaysUseLowerCamelCase
  static func fromList(_ pigeonVar_list: [Any?]) -> PgLatLng? {
    let latitude = pigeonVar_list[0] as! Double
    let longitude = pigeonVar_list[1] as! Double

    return PgLatLng(
      latitude: latitude,
      longitude: longitude
    )
  }
  func toList() -> [Any?] {
    return [
      latitude,
      longitude,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct PgRouteOptionsUpdatedMessage {
  var origin: PgLatLng
  var destination: PgLatLng
  var routeOptions: [PgRouteOption?]



  // swift-format-ignore: AlwaysUseLowerCamelCase
  static func fromList(_ pigeonVar_list: [Any?]) -> PgRouteOptionsUpdatedMessage? {
    let origin = pigeonVar_list[0] as! PgLatLng
    let destination = pigeonVar_list[1] as! PgLatLng
    let routeOptions = pigeonVar_list[2] as! [PgRouteOption?]

    return PgRouteOptionsUpdatedMessage(
      origin: origin,
      destination: destination,
      routeOptions: routeOptions
    )
  }
  func toList() -> [Any?] {
    return [
      origin,
      destination,
      routeOptions,
    ]
  }
}

private class CarPigeonCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
    case 129:
      return PgRouteOption.fromList(self.readValue() as! [Any?])
    case 130:
      return PgLatLng.fromList(self.readValue() as! [Any?])
    case 131:
      return PgRouteOptionsUpdatedMessage.fromList(self.readValue() as! [Any?])
    default:
      return super.readValue(ofType: type)
    }
  }
}

private class CarPigeonCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? PgRouteOption {
      super.writeByte(129)
      super.writeValue(value.toList())
    } else if let value = value as? PgLatLng {
      super.writeByte(130)
      super.writeValue(value.toList())
    } else if let value = value as? PgRouteOptionsUpdatedMessage {
      super.writeByte(131)
      super.writeValue(value.toList())
    } else {
      super.writeValue(value)
    }
  }
}

private class CarPigeonCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return CarPigeonCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return CarPigeonCodecWriter(data: data)
  }
}

class CarPigeonCodec: FlutterStandardMessageCodec, @unchecked Sendable {
  static let shared = CarPigeonCodec(readerWriter: CarPigeonCodecReaderWriter())
}

/// Generated protocol from Pigeon that represents Flutter messages that can be called from Swift.
protocol CarToFlutterApiProtocol {
  func setupMapView(completion: @escaping (Result<Void, PigeonError>) -> Void)
  func updateSelectedRouteOption(routeOptionIndex routeOptionIndexArg: Int64, completion: @escaping (Result<Void, PigeonError>) -> Void)
  func stopRouting(completion: @escaping (Result<Void, PigeonError>) -> Void)
  func onDisconnect(completion: @escaping (Result<Void, PigeonError>) -> Void)
}
class CarToFlutterApi: CarToFlutterApiProtocol {
  private let binaryMessenger: FlutterBinaryMessenger
  private let messageChannelSuffix: String
  init(binaryMessenger: FlutterBinaryMessenger, messageChannelSuffix: String = "") {
    self.binaryMessenger = binaryMessenger
    self.messageChannelSuffix = messageChannelSuffix.count > 0 ? ".\(messageChannelSuffix)" : ""
  }
  var codec: CarPigeonCodec {
    return CarPigeonCodec.shared
  }
  func setupMapView(completion: @escaping (Result<Void, PigeonError>) -> Void) {
    let channelName: String = "dev.flutter.pigeon.here_sdk_reference_application_flutter.CarToFlutterApi.setupMapView\(messageChannelSuffix)"
    let channel = FlutterBasicMessageChannel(name: channelName, binaryMessenger: binaryMessenger, codec: codec)
    channel.sendMessage(nil) { response in
      guard let listResponse = response as? [Any?] else {
        completion(.failure(createConnectionError(withChannelName: channelName)))
        return
      }
      if listResponse.count > 1 {
        let code: String = listResponse[0] as! String
        let message: String? = nilOrValue(listResponse[1])
        let details: String? = nilOrValue(listResponse[2])
        completion(.failure(PigeonError(code: code, message: message, details: details)))
      } else {
        completion(.success(Void()))
      }
    }
  }
  func updateSelectedRouteOption(routeOptionIndex routeOptionIndexArg: Int64, completion: @escaping (Result<Void, PigeonError>) -> Void) {
    let channelName: String = "dev.flutter.pigeon.here_sdk_reference_application_flutter.CarToFlutterApi.updateSelectedRouteOption\(messageChannelSuffix)"
    let channel = FlutterBasicMessageChannel(name: channelName, binaryMessenger: binaryMessenger, codec: codec)
    channel.sendMessage([routeOptionIndexArg] as [Any?]) { response in
      guard let listResponse = response as? [Any?] else {
        completion(.failure(createConnectionError(withChannelName: channelName)))
        return
      }
      if listResponse.count > 1 {
        let code: String = listResponse[0] as! String
        let message: String? = nilOrValue(listResponse[1])
        let details: String? = nilOrValue(listResponse[2])
        completion(.failure(PigeonError(code: code, message: message, details: details)))
      } else {
        completion(.success(Void()))
      }
    }
  }
  func stopRouting(completion: @escaping (Result<Void, PigeonError>) -> Void) {
    let channelName: String = "dev.flutter.pigeon.here_sdk_reference_application_flutter.CarToFlutterApi.stopRouting\(messageChannelSuffix)"
    let channel = FlutterBasicMessageChannel(name: channelName, binaryMessenger: binaryMessenger, codec: codec)
    channel.sendMessage(nil) { response in
      guard let listResponse = response as? [Any?] else {
        completion(.failure(createConnectionError(withChannelName: channelName)))
        return
      }
      if listResponse.count > 1 {
        let code: String = listResponse[0] as! String
        let message: String? = nilOrValue(listResponse[1])
        let details: String? = nilOrValue(listResponse[2])
        completion(.failure(PigeonError(code: code, message: message, details: details)))
      } else {
        completion(.success(Void()))
      }
    }
  }
  func onDisconnect(completion: @escaping (Result<Void, PigeonError>) -> Void) {
    let channelName: String = "dev.flutter.pigeon.here_sdk_reference_application_flutter.CarToFlutterApi.onDisconnect\(messageChannelSuffix)"
    let channel = FlutterBasicMessageChannel(name: channelName, binaryMessenger: binaryMessenger, codec: codec)
    channel.sendMessage(nil) { response in
      guard let listResponse = response as? [Any?] else {
        completion(.failure(createConnectionError(withChannelName: channelName)))
        return
      }
      if listResponse.count > 1 {
        let code: String = listResponse[0] as! String
        let message: String? = nilOrValue(listResponse[1])
        let details: String? = nilOrValue(listResponse[2])
        completion(.failure(PigeonError(code: code, message: message, details: details)))
      } else {
        completion(.success(Void()))
      }
    }
  }
}
/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol FlutterToCarApi {
  func onStartRouting() throws
  func onRouteOptionsUpdated(message: PgRouteOptionsUpdatedMessage) throws
  func onRouteOptionSelected(routeOptionIndex: Int64) throws
  func onStopRouting() throws
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class FlutterToCarApiSetup {
  static var codec: FlutterStandardMessageCodec { CarPigeonCodec.shared }
  /// Sets up an instance of `FlutterToCarApi` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: FlutterToCarApi?, messageChannelSuffix: String = "") {
    let channelSuffix = messageChannelSuffix.count > 0 ? ".\(messageChannelSuffix)" : ""
    let onStartRoutingChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.here_sdk_reference_application_flutter.FlutterToCarApi.onStartRouting\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      onStartRoutingChannel.setMessageHandler { _, reply in
        do {
          try api.onStartRouting()
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      onStartRoutingChannel.setMessageHandler(nil)
    }
    let onRouteOptionsUpdatedChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.here_sdk_reference_application_flutter.FlutterToCarApi.onRouteOptionsUpdated\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      onRouteOptionsUpdatedChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let messageArg = args[0] as! PgRouteOptionsUpdatedMessage
        do {
          try api.onRouteOptionsUpdated(message: messageArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      onRouteOptionsUpdatedChannel.setMessageHandler(nil)
    }
    let onRouteOptionSelectedChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.here_sdk_reference_application_flutter.FlutterToCarApi.onRouteOptionSelected\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      onRouteOptionSelectedChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let routeOptionIndexArg = args[0] as! Int64
        do {
          try api.onRouteOptionSelected(routeOptionIndex: routeOptionIndexArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      onRouteOptionSelectedChannel.setMessageHandler(nil)
    }
    let onStopRoutingChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.here_sdk_reference_application_flutter.FlutterToCarApi.onStopRouting\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      onStopRoutingChannel.setMessageHandler { _, reply in
        do {
          try api.onStopRouting()
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      onStopRoutingChannel.setMessageHandler(nil)
    }
  }
}
