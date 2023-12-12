import 'package:flutter/material.dart';
import 'dart:async';

import 'package:xprinter/xprinter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _xprinterPlugin = Xprinter();

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    final connection = await _xprinterPlugin.connect('192.168.1.99');
    setState(() {
      _platformVersion = connection.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Center(
              child: Text('Running on: $_platformVersion'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async => await initPlatformState(),
                child: const Text('Connect'))
          ],
        ),
      ),
    );
  }
}
