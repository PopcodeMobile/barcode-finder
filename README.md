

A barcode scanner that works on both iOS and Android. Provides functionality for scanning 1D and 2D barcodes.
It uses Zxing on Android and Zxing+Zbar on iOS.

---
<img src="https://github.com/PopcodeMobile/barcode-finder/blob/feature/scan-file/example/barcodefinder.gif" width="200"/>

## Usage

Lets take a look at how to use `BarcodeFinder` to scan any PDF or image `File`.
```dart
// File file = ... 
final String barcode =  await _barcodeFinder.scanFile(filePath: file.path);
```

