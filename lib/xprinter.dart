import 'xprinter_method_channel.dart';

class Xprinter {
  final channel = MethodChannelXprinter();

  bool _connected = false;

  bool get isConnected => _connected;

  Future<bool> connect(String ip) async {
    _connected = await channel.connect(ip);
    return _connected;
  }
}
