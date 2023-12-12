import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'xprinter_method_channel.dart';

abstract class XprinterPlatform extends PlatformInterface {
  /// Constructs a XprinterPlatform.
  XprinterPlatform() : super(token: _token);

  static final Object _token = Object();

  static XprinterPlatform _instance = MethodChannelXprinter();

  /// The default instance of [XprinterPlatform] to use.
  ///
  /// Defaults to [MethodChannelXprinter].
  static XprinterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [XprinterPlatform] when
  /// they register themselves.
  static set instance(XprinterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> connect(String ip);

  // Future<bool> disconnect();

  // Future<String> status();

  // Future<bool> sendCommand(String command);

  // Future<bool> sendCommandAndFile(String command, String filepath);
}
