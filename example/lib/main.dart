import 'dart:io';

import 'package:barcode_finder_example/app/barcode_finder_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final controller = BarcodeFinderController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Barcode Finder',
          ),
        ),
        body: Center(
          child: AnimatedBuilder(
            animation: controller,
            builder: (_, __) {
              final state = controller.state;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Code:',
                    textAlign: TextAlign.center,
                  ),
                  if (state is BarcodeFinderLoading)
                    _loading()
                  else if (state is BarcodeFinderError)
                    _text(
                      '${state.message}',
                    )
                  else if (state is BarcodeFinderSuccess)
                    _text(
                      '${state.code}',
                    ),
                  _startScanFileButton(state),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _startScanFileButton(BarcodeFinderState state) {
    return ElevatedButton(
      child: Text('Scan PDF or image file'),
      onPressed: state is! BarcodeFinderLoading
          ? () async {
              FilePickerResult? pickedFile =
                  await FilePicker.platform.pickFiles();
              if (pickedFile != null) {
                String? filePath = pickedFile.files.single.path;
                if (filePath != null) {
                  final file = File(filePath);
                  controller.scanFile(file);
                }
              }
            }
          : null,
    );
  }

  Widget _loading() => Center(child: CircularProgressIndicator());

  Text _text(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
    );
  }
}
