import Flutter
import UIKit

public class SwiftBarcodeFinderPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "popcode.com.br/barcode_finder", binaryMessenger: registrar.messenger())
        let instance = SwiftBarcodeFinderPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(call.method == "scan_pdf") {
            guard let args = call.arguments else {
                return
            }
            if let myArgs = args as? [String: Any]{
                let filePath = myArgs["filePath"] as! String
                let barcodeFormats = myArgs["barcodeFormats"] as? [String]
                let url = URL(fileURLWithPath: filePath)
                let scanner = BarcodeScanner()
                
                DispatchQueue.global().async {
                    let pdfImages = url.pdfPagesToImages()
                    DispatchQueue.main.async {
                        if pdfImages == nil{
                            result(nil)
                            return
                        }
                        let barcodesToFilter = BarcodeFormatType.createBarcodeFormatTypeFromStrings(strings: barcodeFormats!)
                        for uiImage in pdfImages ?? [UIImage](){
                            let barcode =  scanner.tryFindBarcodeFrom(uiImage: uiImage, barcodesToFilter: barcodesToFilter)
                            if barcode != nil {
                                result(barcode)
                                return;
                            }
                        }
                        
                        result(nil)
                    }
                }
                
                
            } else {
                result(nil)
            }
        }
        if(call.method == "scan_image") {
            guard let args = call.arguments else {
                return
            }
            if let myArgs = args as? [String: Any]{
                let filePath = myArgs["filePath"] as! String
                let barcodeFormats = myArgs["barcodeFormats"] as? [String]
                let url = URL(fileURLWithPath: filePath)
                let scanner = BarcodeScanner()
                let uiImage = UIImage.init(contentsOfFile: url.path)
                if uiImage == nil{
                    result(nil)
                    return
                }
                let barcodesToFilter = BarcodeFormatType.createBarcodeFormatTypeFromStrings(strings: barcodeFormats!)
                let barcode =  scanner.tryFindBarcodeFrom(uiImage: uiImage!, barcodesToFilter: barcodesToFilter)
                if barcode != nil {
                    result(barcode)
                    return;
                }
                result(nil)
            } else {
                result(nil)
            }
        }
    }
}
