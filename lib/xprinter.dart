import 'package:flutter/services.dart';

import 'xprinter_method_channel.dart';

class Xprinter {
  final channel = MethodChannelXprinter();

  bool _connected = false;

  bool get isConnected => _connected;

  // Future<bool> connect(String ip) async {
  //   _connected = await channel.connect(ip);
  //   return _connected;
  // }

  // Future<bool> sendCommand(String command) async {
  //   _connected = await channel.sendCommand(command);
  //   return _connected;
  // }

  // Future<bool> sendCommand(Uint8List bitmapBytes) async {
  //   _connected = await channel.sendCommand(bitmapBytes);
  //   return _connected;
  // }

  Future<bool> sendToPrint({
    required String ip,
    required Uint8List imageBytes,
    required int amount,
  }) async {
    _connected = await channel.sendToPrint(
      imageBytes: imageBytes,
      ip: ip,
      amount: amount,
    );
    return _connected;
  }

  // Future<bool> sendCommandAndFile(String command, String filepath) {
  //   return channel.sendCommandAndFile(command, filepath);
  // }

  // Future<String> status() {
  //   return channel.status();
  // }
}
