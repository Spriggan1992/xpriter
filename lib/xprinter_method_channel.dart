import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'xprinter_platform_interface.dart';

/// An implementation of [XprinterPlatform] that uses method channels.
class MethodChannelXprinter extends XprinterPlatform {
  MethodChannelXprinter() {
    _listenEvents();
  }

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('xprinter');

  @visibleForTesting
  final eventChannel = const EventChannel('xprinter_event');

  final StreamController<int> _status = StreamController();

  final StreamController<bool> _loading = StreamController();

  @override
  Stream<int> get statusStream => _status.stream;

  @override
  Stream<bool> get loadingStream => _loading.stream;

  void _listenEvents() {
    eventChannel.receiveBroadcastStream().listen((event) {
      if (event is bool) {
        _loading.sink.add(event);
      }
      if (event is int) {
        _status.sink.add(event);
      }
    });
  }

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
  Future<bool> sendToPrintBytes({
    required Uint8List imageBytes,
    required int amount,
  }) async {
    return await methodChannel.invokeMethod('print', {
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
  Future<bool> disconnect() async {
    return await methodChannel.invokeMethod<bool>('disconnect') ?? false;
  }

  @override
  Future<bool> checkConnection() async {
    return await methodChannel.invokeMethod<bool>('check_connection') ?? false;
  }
}
