//
//  ZBarScanImage.swift
//  barcode_finder
//
//  Created by Rafael Aquila on 25/12/20.
//

import Foundation
import ATBarSDK

func zbarScanImage(_ image: UIImage, barcodesToFilter: [BarcodeFormatType]) -> String?{
    let reader = ZBarReaderController()
    reader.scanner.addSymbologiesFor(barcodesToFilter)
    guard reader.scanner.scanImage(ZBarImage(cgImage: image.cgImage!)) > 0 else{
        return nil
    }
    guard let symbolFound = reader.scanner.results.symbolFound else {
        return nil
    }
    return symbolFound.stringFromData
    
}

extension ZBarImageScanner{
    func addSymbologiesFor(_ barcodesToFilter: [BarcodeFormatType]){
        if barcodesToFilter.contains(.any){
            addSymbologyFrom(.any)
            return
        }
        for barcodeType in barcodesToFilter{
            addSymbologyFrom(barcodeType)
            
        }
        
    }
    
    private func addSymbologyFrom(_ barcodeFormatType:  BarcodeFormatType){
        self.setSymbology(ZBAR_NONE, config: ZBAR_CFG_ENABLE, to:0)

        switch barcodeFormatType {
        case .any:
            self.setSymbology(ZBAR_NONE, config: ZBAR_CFG_ENABLE, to:1)
            self.setSymbology(ZBAR_NONE, config: ZBAR_CFG_X_DENSITY, to: 3)
            self.setSymbology(ZBAR_NONE, config: ZBAR_CFG_Y_DENSITY, to: 3)
        case .upcA:
            self.setSymbology(ZBAR_UPCA, config: ZBAR_CFG_ENABLE, to:1)
            self.setSymbology(ZBAR_UPCA, config: ZBAR_CFG_X_DENSITY, to: 3)
            self.setSymbology(ZBAR_UPCA, config: ZBAR_CFG_Y_DENSITY, to: 3)
        case .upcE:
            self.setSymbology(ZBAR_UPCE, config: ZBAR_CFG_ENABLE, to:1)
            self.setSymbology(ZBAR_UPCE, config: ZBAR_CFG_X_DENSITY, to: 3)
            self.setSymbology(ZBAR_UPCE, config: ZBAR_CFG_Y_DENSITY, to: 3)
        case .ean8:
            self.setSymbology(ZBAR_EAN8, config: ZBAR_CFG_ENABLE, to:1)
            self.setSymbology(ZBAR_EAN8, config: ZBAR_CFG_X_DENSITY, to: 3)
            self.setSymbology(ZBAR_EAN8, config: ZBAR_CFG_Y_DENSITY, to: 3)
        case .ean13:
            self.setSymbology(ZBAR_EAN13, config: ZBAR_CFG_ENABLE, to:1)
            self.setSymbology(ZBAR_EAN13, config: ZBAR_CFG_X_DENSITY, to: 3)
            self.setSymbology(ZBAR_EAN13, config: ZBAR_CFG_Y_DENSITY, to: 3)
        case .upcEanExtension:
            self.setSymbology(ZBAR_COMPOSITE, config: ZBAR_CFG_ENABLE, to:1)
            self.setSymbology(ZBAR_COMPOSITE, config: ZBAR_CFG_X_DENSITY, to: 3)
            self.setSymbology(ZBAR_COMPOSITE, config: ZBAR_CFG_Y_DENSITY, to: 3)
        case .code39:
            self.setSymbology(ZBAR_CODE39, config: ZBAR_CFG_ENABLE, to:1)
            self.setSymbology(ZBAR_CODE39, config: ZBAR_CFG_X_DENSITY, to: 3)
            self.setSymbology(ZBAR_CODE39, config: ZBAR_CFG_Y_DENSITY, to: 3)
        case .code93:
            self.setSymbology(ZBAR_CODE93, config: ZBAR_CFG_ENABLE, to:1)
            self.setSymbology(ZBAR_CODE93, config: ZBAR_CFG_X_DENSITY, to: 3)
            self.setSymbology(ZBAR_CODE93, config: ZBAR_CFG_Y_DENSITY, to: 3)
        case .code128:
            self.setSymbology(ZBAR_CODE128, config: ZBAR_CFG_ENABLE, to:1)
            self.setSymbology(ZBAR_CODE128, config: ZBAR_CFG_X_DENSITY, to: 3)
            self.setSymbology(ZBAR_CODE128, config: ZBAR_CFG_Y_DENSITY, to: 3)
        case .codabar:
            self.setSymbology(ZBAR_CODABAR, config: ZBAR_CFG_ENABLE, to:1)
            self.setSymbology(ZBAR_CODABAR, config: ZBAR_CFG_X_DENSITY, to: 3)
            self.setSymbology(ZBAR_CODABAR, config: ZBAR_CFG_Y_DENSITY, to: 3)
        case .itf:
            self.setSymbology(ZBAR_I25, config: ZBAR_CFG_ENABLE, to:1)
            self.setSymbology(ZBAR_I25, config: ZBAR_CFG_X_DENSITY, to: 3)
            self.setSymbology(ZBAR_I25, config: ZBAR_CFG_Y_DENSITY, to: 3)
        case .qr:
            self.setSymbology(ZBAR_QRCODE, config: ZBAR_CFG_ENABLE, to:1)
            self.setSymbology(ZBAR_QRCODE, config: ZBAR_CFG_X_DENSITY, to: 3)
            self.setSymbology(ZBAR_QRCODE, config: ZBAR_CFG_Y_DENSITY, to: 3)
        case .dataMatrix:
            self.setSymbology(ZBAR_NONE, config: ZBAR_CFG_ENABLE, to:0)
        case .aztec:
            self.setSymbology(ZBAR_NONE, config: ZBAR_CFG_ENABLE, to:0)
        case .pdf417:
            self.setSymbology(ZBAR_PDF417, config: ZBAR_CFG_ENABLE, to:1)
            self.setSymbology(ZBAR_PDF417, config: ZBAR_CFG_X_DENSITY, to: 3)
            self.setSymbology(ZBAR_PDF417, config: ZBAR_CFG_Y_DENSITY, to: 3)
        case .maxicode:
            self.setSymbology(ZBAR_NONE, config: ZBAR_CFG_ENABLE, to:0)
        case .rss14:
            self.setSymbology(ZBAR_DATABAR, config: ZBAR_CFG_ENABLE, to:1)
            self.setSymbology(ZBAR_DATABAR, config: ZBAR_CFG_X_DENSITY, to: 3)
            self.setSymbology(ZBAR_DATABAR, config: ZBAR_CFG_Y_DENSITY, to: 3)
        case .rssexpanded:
            self.setSymbology(ZBAR_DATABAR_EXP, config: ZBAR_CFG_ENABLE, to:1)
            self.setSymbology(ZBAR_DATABAR_EXP, config: ZBAR_CFG_X_DENSITY, to: 3)
            self.setSymbology(ZBAR_DATABAR_EXP, config: ZBAR_CFG_Y_DENSITY, to: 3)
        }
    }
}

extension ZBarSymbolSet: Sequence {
    
    public func makeIterator() -> NSFastEnumerationIterator {
        return NSFastEnumerationIterator(self)
    }
    
    var symbolFound: ZBarSymbol? {
        var symbolFound: ZBarSymbol?
        for symbol in self {
            symbolFound = symbol as? ZBarSymbol
            break
        }
        return symbolFound
    }
}

extension ZBarSymbol {
    
    var stringFromData: String {
        return NSString(string: self.data) as String
    }
}
