import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'dart:async';
// import 'package:pdf_render/pdf_render.dart';
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

  bool? _isLoading;

  final _xprinterPlugin = Xprinter();

  @override
  void initState() {
    // connect();
    // _xprinterPlugin.status.listen((event) {
    //   log(event.statusString);
    //   setState(() {
    //     _platformVersion = event.statusString;
    //   });
    // });
    // _xprinterPlugin.loading.listen((event) {
    //   log(event.toString());
    //   setState(() {
    //     _isLoading = event;
    //   });
    // });
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // final connection = await _xprinterPlugin.connect('192.168.1.99');
    setState(() {
      // _platformVersion = connection.toString();
    });
  }

  Future<void> printBytes() async {
    final bytes = await PdfService().getbitmap();
    final connection =
        await _xprinterPlugin.sendToPrintBytes(imageBytes: bytes, amount: 1);
    setState(() {
      _platformVersion = connection.toString();
    });
  }

  Future<void> printFilePath() async {
    final bytes = await PdfService().getbitmap();
    final file = await PdfService().getFileFromAssets(bytes);

    final connection = await _xprinterPlugin.sendToPrintFilePath(
        ip: '192.168.1.99', path: file.path, amount: 1);
    setState(() {
      _platformVersion = connection.toString();
    });
  }

  Future<void> connect() async {
    // final bytes = await PdfService().getbitmap();
    await _xprinterPlugin.connect('192.168.1.99');
  }

  Future<void> disconnect() async {
    // final bytes = await PdfService().getbitmap();
    await _xprinterPlugin.disconnect();
  }

  Future<void> checkConnect() async {
    // final bytes = await PdfService().getbitmap();
    final connection = await _xprinterPlugin.checkConnection();
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
                onPressed: () async => await connect(),
                child: const Text('connect')),
            ElevatedButton(
                onPressed: () async => await disconnect(),
                child: const Text('disconnect')),
            ElevatedButton(
                onPressed: () async => await printBytes(),
                child: const Text('print bytes')),
            ElevatedButton(
                onPressed: () async => await checkConnect(),
                child: const Text('check connection')),
          ],
        ),
      ),
    );
  }
}

class PdfService {
  Future<Uint8List> getbitmap() async {
    ByteData data = await rootBundle.load('assets/images/sticker5.jpeg');
    // final file = await DefaultCacheManager().getSingleFile(
    //     'github.com/Spriggan1992/test/blob/main/sample1_page-0001.jpg');

    final pdfBytes = data.buffer.asUint8List();
    // final pdfBytes = await file.readAsBytes();

    return pdfBytes;
  }

  Future<File> getFileFromAssets(Uint8List bytes) async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    var filePath = '$tempPath/sticker.jpeg';

    return File(filePath).writeAsBytes(bytes);
  }

  Future<Uint8List> getPdfBytes() async {
    // Replace 'assets/sample.pdf' with the actual path to your PDF in assets
    final pdfAssetPath = 'assets/images/sample1.pdf';

    // Fetch the PDF file from assets using flutter_cache_manager
    final file = await DefaultCacheManager().getSingleFile(pdfAssetPath);

    // Read the PDF content and convert it to bytes
    final pdfBytes = await file.readAsBytes();

    return pdfBytes;
  }

  Future<Uint8List> _getBytes() async {
    ByteData byteData =
        await rootBundle.load('assets/images/sample_page_2.jpg');
    Uint8List bitmapBytes = byteData.buffer.asUint8List();

    return await getImageFromPdf(bitmapBytes);
  }

  Future<Uint8List> getImageFromPdf(Uint8List documentBytes) async {
    late Uint8List imageBytes;

    await for (var page
        in Printing.raster(documentBytes, pages: [0], dpi: 72)) {
      imageBytes = await page.toPng(); // ...or page.toPng()
    }
    return imageBytes;
  }

  imageFromPdfFile(File pdfFile) async {
    final pdf = await rootBundle.load('document.pdf');
    final a =
        await Printing.layoutPdf(onLayout: (_) => pdf.buffer.asUint8List());

    //... now convert
    // .... pageImage.bytes to image
  }
}
