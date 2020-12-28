import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

abstract class BarcodeFinder {
  static const _channel = const MethodChannel('barcode_finder');

  static Future<String> scanFile({@required String path}) async {
    try {
      if (path.endsWith('.pdf')) {
        return _channel.invokeMethod('scan_pdf', path);
      }
      return _channel.invokeMethod('scan_image', path);
    } catch (e) {
      throw Exception();
    }
  }
}
