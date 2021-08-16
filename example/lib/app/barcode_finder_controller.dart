import 'dart:io';

import 'package:barcode_finder/barcode_finder.dart';
import 'package:flutter/widgets.dart';

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
      final barcode = await BarcodeFinder.scanFile(
        path: file.path,
      );
      _update(barcode);
    } catch (_) {
      _emit(
        BarcodeFinderError('Not found'),
      );
    }
  }

  void _emit(BarcodeFinderState newState) {
    state = newState;
    notifyListeners();
  }

  void _update(String? barcode) {
    if (barcode != null) {
      _emit(
        BarcodeFinderSuccess(barcode),
      );
    } else {
      _emit(
        BarcodeFinderError('Not Found'),
      );
    }
  }
}
