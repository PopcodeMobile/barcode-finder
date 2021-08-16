import 'package:flutter/services.dart';

abstract class BarcodeFinder {
  static const _channel = const MethodChannel('popcode.com.br/barcode_finder');

  /// If [formats] parameter is an empty list
  /// it will scan for all possible formats
  static Future<String?> scanFile({
    required String path,
    List<BarcodeFormat> formats = const [],
  }) async {
    try {
      final listFormats = _conventFormatsToList(formats);
      Map<String, dynamic> arguments = {
        'filePath': path,
        'barcodeFormats': listFormats,
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

enum BarcodeFormat {
  UPC_A,
  UPC_E,
  EAN_8,
  EAN_13,
  UPC_EAN_EXTENSION,
  CODE_39,
  CODE_93,
  CODE_128,
  CODABAR,
  ITF,
  QR_CODE,
  DATA_MATRIX,
  AZTEC,
  PDF_417,
  MAXICODE,
  RSS_14,
  RSS_EXPANDED,
}
