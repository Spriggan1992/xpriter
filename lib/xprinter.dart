import 'package:flutter/services.dart';

import 'xprinter_method_channel.dart';

class Xprinter {
  final channel = MethodChannelXprinter();

  Future<bool> connect(String ip) async {
    return await channel.connect(ip);
  }

  Future<bool> checkConnection() async {
    return await channel.checkConnection();
  }

  Future<bool> sendToPrintBytes({
    required String ip,
    required Uint8List imageBytes,
    required int amount,
  }) async {
    return await channel.sendToPrintBytes(
      imageBytes: imageBytes,
      ip: ip,
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
