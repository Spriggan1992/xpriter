import 'package:flutter/services.dart';
import 'package:xprinter/status_type.dart';

import 'xprinter_method_channel.dart';

class Xprinter {
  final channel = MethodChannelXprinter();

  Future<bool> connect(String ip) async {
    return await channel.connect(ip);
  }

  Stream<StatusType> get status =>
      channel.statusSubscription.map((event) => StatusType.fromValue(event));

  Future<void> disconnect() async {
    return await channel.disconnect();
  }

  Future<bool> checkConnection() async {
    return await channel.checkConnection();
  }

  Future<bool> checkConnectionWithStatus() async {
    return await channel.checkConnectionWithStatus();
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
