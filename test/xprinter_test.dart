// import 'package:flutter_test/flutter_test.dart';
// import 'package:xprinter/xprinter.dart';
// import 'package:xprinter/xprinter_platform_interface.dart';
// import 'package:xprinter/xprinter_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockXprinterPlatform
//     with MockPlatformInterfaceMixin
//     implements XprinterPlatform {
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final XprinterPlatform initialPlatform = XprinterPlatform.instance;

//   test('$MethodChannelXprinter is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelXprinter>());
//   });

//   test('getPlatformVersion', () async {
//     XPrinter xprinterPlugin = XPrinter();
//     MockXprinterPlatform fakePlatform = MockXprinterPlatform();
//     XprinterPlatform.instance = fakePlatform;

//     expect(await xprinterPlugin.getPlatformVersion(), '42');
//   });
// }
