//
//  BarcodeFormatType.swift
//  barcode_finder
//
//  Created by Rafael Aquila on 25/12/20.
//

import Foundation
import MLKit

enum BarcodeFormatType {
    case all, code128, code39, code93, codaBar, dataMatrix, EAN13, EAN8, ITF, qrCode, UPCA, UPCE
                , PDF417, Aztec
    
    static func createBarcodeFormatTypeFromStrings(strings: [String]) ->[BarcodeFormat]{
        if strings.isEmpty{
            return [BarcodeFormat.all]
        }
        var barcodeFormatTypes = Array<BarcodeFormat>()
        for name in strings{
            barcodeFormatTypes.append(barcodeFormatTypeFromString(name))
        }
        return barcodeFormatTypes
    }
    
    static private func barcodeFormatTypeFromString(_ name: String) -> BarcodeFormat{
        switch name {
        case "UPC_A":
            return BarcodeFormat.upca
        case "UPC_E":
            return BarcodeFormat.upce
        case "EAN_8":
            return BarcodeFormat.ean8
        case "EAN_13":
            return BarcodeFormat.ean13
        case "CODE_39":
            return BarcodeFormat.code39
        case "CODE_93":
            return BarcodeFormat.code93
        case "CODE_128":
            return BarcodeFormat.code128
        case "CODABAR":
            return BarcodeFormat.codabar
        case "ITF":
            return BarcodeFormat.itf
        case "QR_CODE":
            return BarcodeFormat.qr
        case "DATA_MATRIX":
            return BarcodeFormat.dataMatrix
        case "AZTEC":
            return BarcodeFormat.aztec
        case "PDF_417":
            return BarcodeFormat.pdf417
        default:
            return BarcodeFormat.all
        
        }
    }

}
