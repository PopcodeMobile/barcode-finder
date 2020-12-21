import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class BarcodeFinder {
  static const _channel = const MethodChannel('barcode_finder');

  Future<String> scanPDF({@required String filePath}) async {
    try {
      return _channel.invokeMethod('scan_pdf', filePath);
    } catch (e) {
      throw Exception();
    }
  }

  Future<String> scanImage({@required String filePath}) async {
    try {
      return _channel.invokeMethod('scan_image', filePath);
    } catch (e) {
      throw Exception();
    }
  }
}
