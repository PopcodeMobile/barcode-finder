import 'dart:async';

import 'package:barcode_finder/barcode_format.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

abstract class BarcodeFinder {
  static const _channel = const MethodChannel('barcode_finder');

  static Future<String> scanFile({
    @required String path,
    List<BarcodeFormat> formats = const [BarcodeFormat.ALL_FORMATS],
  }) async {
    try {
      final list = _conventFormatsToList(formats);
      if (path.endsWith('.pdf')) {
        return _channel.invokeMethod(
          'scan_pdf',
          [path, list],
        );
      }
      return _channel.invokeMethod(
        'scan_image',
        [path, list],
      );
    } catch (e) {
      throw Exception();
    }
  }

  static List<String> _conventFormatsToList(List<BarcodeFormat> formats) {
    return formats.map((format) => format.toString()).toList();
  }
}
