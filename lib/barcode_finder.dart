import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class BarcodeFinder {
  static const _channel = const MethodChannel('barcode_finder');

  Future<String> scanFile({@required String filePath}) async {
    try {
      if (filePath.endsWith('.pdf')) {
        return _channel.invokeMethod('scan_pdf', filePath);
      }
      return _channel.invokeMethod('scan_image', filePath);
    } catch (e) {
      throw Exception();
    }
  }
}
