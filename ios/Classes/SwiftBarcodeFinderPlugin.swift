import Flutter
import UIKit

public class SwiftBarcodeFinderPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "barcode_finder", binaryMessenger: registrar.messenger())
    let instance = SwiftBarcodeFinderPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if(call.method == "scan_pdf") {
                guard let args = call.arguments else {
                    return
                }
                if let filePath = args as? String{
                    let url = URL(fileURLWithPath: filePath)
                    let conversor = PDFToBarcodeConversor()
                    let zxResult = conversor.tryDecodeBarcodeFromPDF(pdfUrl: url, tryOnlyOnce: false)
                    if let barcodeResult = zxResult {
                        result(barcodeResult.text)
                    }
                    result(nil)
                } else {
                    result(nil)
                }
            }
    if(call.method == "scan_image") {
                guard let args = call.arguments else {
                    return
                }
                if let filePath = args as? String{
                    let url = URL(fileURLWithPath: filePath)
                    let conversor = ImageToBarcodeConversor()
                    let zxResult = conversor.tryDecodeBarcodeFromFileImage(imageUrl: url, tryOnlyOnce: false)
                    if let barcodeResult = zxResult {
                        result(barcodeResult.text)
                    }
                    result(nil)
                } else {
                    result(nil)
                }
            }
  }
}
