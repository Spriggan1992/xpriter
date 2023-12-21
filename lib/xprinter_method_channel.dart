import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'xprinter_platform_interface.dart';

/// An implementation of [XprinterPlatform] that uses method channels.
class MethodChannelXprinter extends XprinterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('xprinter');

  @visibleForTesting
  final eventChannel = const EventChannel('xprinter');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  // @override
  // Future<bool> connect(String ip) async {
  //   final status =
  //       await methodChannel.invokeMethod<bool>('connect', {"ip": ip});
  //   return status ?? false;
  // }

  // @override
  // Future<String> status() async {
  //   return await methodChannel.invokeMethod('status');
  // }

  // @override
  // Future<bool> sendCommand(String command) async {
  //   return await methodChannel
  //       .invokeMethod("send_command", {"command": command});
  // }
  @override
  Future<bool> sendToPrint({
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

  // @override
  // Future<bool> sendFile(String filepath) async {
  //   return await methodChannel
  //       .invokeMethod("print_file", {"file_path": filepath});
  // }

  // @override
  // Future<bool> sendCommandAndFile(String command, String filepath) async {
  //   return await methodChannel.invokeMethod(
  //       "send_command_and_file", {"command": command, "filepath": filepath});
  // }
}
