import 'package:flutter/services.dart';
import 'package:xprinter/status_type.dart';
import 'package:xprinter/xprinter_platform_interface.dart';

import 'xprinter_method_channel.dart';

class Xprinter {
  final XprinterPlatform channel = MethodChannelXprinter();

  Future<bool> connect(String ip) async {
    return await channel.connect(ip);
  }

  Future<bool> checkConnection() async {
    return await channel.checkConnection();
  }

  Stream<StatusType> get status =>
      channel.statusStream.map((event) => StatusType.fromValue(event));

  Stream<bool> get loading => channel.loadingStream.map((event) => event);

  Future<bool> disconnect() async {
    return await channel.disconnect();
  }

  Future<bool> sendToPrintBytes({
    required Uint8List imageBytes,
    required int amount,
  }) async {
    return await channel.sendToPrintBytes(
      imageBytes: imageBytes,
      amount: amount,
    );
  }

  Future<bool> sendToPrintFilePath({
    required String ip,
    required String path,
    required int amount,
  }) async {
    return await channel.sendToPrintFilePath(
      path: path,
      ip: ip,
      amount: amount,
    );
  }
}
