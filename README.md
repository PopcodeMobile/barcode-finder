# Barcode Finder

A flutter plugin for barcode scanner that works on both iOS and Android. Provides functionality for scanning several formats of 1D and 2D barcodes.

It uses [Zxing](https://github.com/zxing/zxing) on Android and [Zxing](https://github.com/zxing/zxing)+[Zbar](https://github.com/ZBar/ZBar) on iOS to detect codes from PDF and Image files.

<img src="https://github.com/PopcodeMobile/barcode-finder/blob/feature/scan-file/example/barcodefinder.gif" width="300" alt="Exemple using app"/>

## Getting Started

###  Depend on it

Add this to your package's pubspec.yaml file:
```yaml
dependencies:
  barcode_finder: latest version
```
### Android Platform

API 21 is the minimum supported for Android.

## Usage

Lets take a look at how to use `BarcodeFinder` to scan any `PDF` or image `File` using [File Picker](https://pub.dev/packages/file_picker) as a auxiliar plugin.

```dart
Future<String> scanFile() async {
    // Used to pick a file from device storage
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if(result != null) {
        String path = result.files.single.path;
        String barcode = await BarcodeFinder.scanFile(path: path);
        return barcode;
    } else {
        // User canceled the picker
        return null;
    }
}
```

Make sure you are passing a valid and permissioned path to `BarcodeFinder.scanFile`, in the exemple above, the package FilePicker provides it for us.
