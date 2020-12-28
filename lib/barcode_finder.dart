import 'dart:async';

import 'package:barcode_finder/barcode_format.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

abstract class BarcodeFinder {
  static const _channel = const MethodChannel('barcode_finder');

  static Future<String> scanFile({
    @required String path,
    List<BarcodeFormat> formats = const [],
  }) async {
    try {
      final listFormats = _conventFormatsToList(formats);
      Map<String, dynamic> arguments = {
        "filePath": path,
        "barcodeFormats": listFormats,
      };
      if (path.endsWith('.pdf')) {
        return _channel.invokeMethod('scan_pdf', arguments);
      }
      return _channel.invokeMethod('scan_image', arguments);
    } catch (e) {
      throw Exception();
    }
  }

  static List<String> _conventFormatsToList(List<BarcodeFormat> formats) {
    return formats.map((format) => format.toString().split('.').last).toList();
  }
}
