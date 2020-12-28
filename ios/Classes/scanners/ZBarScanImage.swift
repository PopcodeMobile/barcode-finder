//
//  ZBarScanImage.swift
//  barcode_finder
//
//  Created by Rafael Aquila on 25/12/20.
//

import Foundation
import ZBarSDK

func zbarScanImage(_ image: UIImage, barcodeType: BarcodeFormatType = .any) -> String?{
    let reader = ZBarReaderController()
    reader.scanner.addSymbologiesFrom(barcodeType: barcodeType)
    guard reader.scanner.scanImage(ZBarImage(cgImage: image.cgImage!)) > 0 else{
        return nil
    }
    guard let symbolFound = reader.scanner.results.symbolFound else {
        return nil
    }
    return symbolFound.stringFromData
    
}

extension ZBarImageScanner{
    
    func addSymbologiesFrom(barcodeType: BarcodeFormatType){
        
        self.setSymbology(ZBAR_NONE, config: ZBAR_CFG_ENABLE, to: 0)
        self.setSymbology(ZBAR_I25, config: ZBAR_CFG_ENABLE, to: 1)
        self.setSymbology(ZBAR_NONE, config: ZBAR_CFG_X_DENSITY, to: 3)
        self.setSymbology(ZBAR_NONE, config: ZBAR_CFG_Y_DENSITY, to: 3)
        // TODO: map BarcodeFormatType to symbology
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
