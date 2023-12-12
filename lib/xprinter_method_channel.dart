import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'xprinter_platform_interface.dart';

/// An implementation of [XprinterPlatform] that uses method channels.
class MethodChannelXprinter extends XprinterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('xprinter');

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
}
