import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'xprinter_platform_interface.dart';

/// An implementation of [XprinterPlatform] that uses method channels.
class MethodChannelXprinter extends XprinterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('xprinter');

  @visibleForTesting
  final eventChannel = const EventChannel('xprinter_event');

  @override
  Stream<int> get statusSubscription => eventChannel
      .receiveBroadcastStream()
      .map((dynamic result) => result as int);

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> connect(String ip) async {
    final status =
        await methodChannel.invokeMethod<bool>('connect', {"ip": ip});
    return status ?? false;
  }

  @override
  Future<bool> checkConnection() async {
    final status = await methodChannel.invokeMethod<bool>('check_connection');
    return status ?? false;
  }

  @override
  Future<bool> sendToPrintBytes({
    required String ip,
    required Uint8List imageBytes,
    required int amount,
  }) async {
    return await methodChannel.invokeMethod('print', {
      'ip': ip,
      'bitmapBytes': imageBytes,
      'amount': amount,
    });
  }

  @override
  Future<bool> sendToPrintFilePath({
    required String ip,
    required String path,
    required int amount,
  }) async {
    return await methodChannel.invokeMethod('print_from_file', {
      'ip': ip,
      'path': path,
      'amount': amount,
    });
  }

  @override
  Future<bool> checkConnectionWithStatus() async {
    final status =
        await methodChannel.invokeMethod<bool>('check_connection_with_status');
    return status ?? false;
  }

  @override
  Future<void> disconnect() async {
    await methodChannel.invokeMethod<bool>('disconnect');
  }
}
