import 'dart:io';
import 'package:barcode_finder/barcode_finder.dart';
import 'package:barcode_finder/barcode_format.dart';
import 'package:flutter/widgets.dart';
import 'package:mime/mime.dart';

abstract class BarcodeFinderState {}

class BarcodeFinderInitial extends BarcodeFinderState {}

class BarcodeFinderLoading extends BarcodeFinderState {}

class BarcodeFinderSuccess extends BarcodeFinderState {
  final String code;
  BarcodeFinderSuccess(this.code);
}

class BarcodeFinderError extends BarcodeFinderState {
  final String message;
  BarcodeFinderError(this.message);
}

class BarcodeFinderController extends ChangeNotifier {
  BarcodeFinderState state = BarcodeFinderInitial();

  void scanFile(File file) async {
    _emit(BarcodeFinderLoading());
    try {
      if (isImageFile(file.path) || isPdfFile(file.path)) {
        final barcode = await BarcodeFinder.scanFile(
          path: file.path,
          formats: [BarcodeFormat.CODABAR],
        );
        _update(barcode);
      } else {
        _emit(BarcodeFinderError('File type not supported.'));
      }
    } catch (e) {
      _update(e.message);
    }
  }

  void _emit(BarcodeFinderState newState) {
    state = newState;
    notifyListeners();
  }

  bool isImageFile(String path) {
    final mime = lookupMimeType(path);
    return mime.contains('image');
  }

  bool isPdfFile(String path) {
    return path.endsWith('.pdf');
  }

  void _update(String barcode) {
    if (barcode != null) {
      _emit(BarcodeFinderSuccess(barcode));
      return;
    }
    _emit(BarcodeFinderError('Not found'));
  }
}
