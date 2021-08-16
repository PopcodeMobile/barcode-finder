//
//  BarcodeFormatType.swift
//  barcode_finder
//
//  Created by Rafael Aquila on 25/12/20.
//

import Foundation
import ZXingObjC

enum BarcodeFormatType {
    case any, upcA, upcE, ean8, ean13, upcEanExtension, code39, code93,
         code128, codabar, itf, qr, dataMatrix, aztec, pdf417, maxicode, rss14, rssexpanded
    
    
    static func createBarcodeFormatTypeFromStrings(strings: [String]) ->[BarcodeFormatType]{
        if strings.isEmpty{
            return [BarcodeFormatType.any]
        }
        var barcodeFormatTypes = Array<BarcodeFormatType>()
        for name in strings{
            barcodeFormatTypes.append(barcodeFormatTypeFromString(name))
        }
        return barcodeFormatTypes
    }
    
    static private func barcodeFormatTypeFromString(_ name: String) -> BarcodeFormatType{
        switch name {
        case "UPC_A":
            return BarcodeFormatType.upcA
        case "UPC_E":
            return BarcodeFormatType.upcE
        case "EAN_8":
            return BarcodeFormatType.ean8
        case "EAN_13":
            return BarcodeFormatType.ean13
        case "UPC_EAN_EXTENSION":
            return BarcodeFormatType.upcEanExtension
        case "CODE_39":
            return BarcodeFormatType.code39
        case "CODE_93":
            return BarcodeFormatType.code93
        case "CODE_128":
            return BarcodeFormatType.code128
        case "CODABAR":
            return BarcodeFormatType.codabar
        case "ITF":
            return BarcodeFormatType.itf
        case "QR_CODE":
            return BarcodeFormatType.qr
        case "DATA_MATRIX":
            return BarcodeFormatType.dataMatrix
        case "AZTEC":
            return BarcodeFormatType.aztec
        case "PDF_417":
            return BarcodeFormatType.pdf417
        case "MAXICODE":
            return BarcodeFormatType.maxicode
        case "RSS_14":
            return BarcodeFormatType.rss14
        case "RSS_EXPANDED":
            return BarcodeFormatType.rssexpanded
        default:
            return BarcodeFormatType.any
        
        }
    }

}
