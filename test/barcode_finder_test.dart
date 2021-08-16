import 'package:barcode_finder/barcode_finder.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const MethodChannel channel = MethodChannel('popcode.com.br/barcode_finder');

  TestWidgetsFlutterBinding.ensureInitialized();

  final tCode = '40020922';

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return tCode;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('scanFile', () async {
    expect(await BarcodeFinder.scanFile(path: ''), tCode);
  });
}
