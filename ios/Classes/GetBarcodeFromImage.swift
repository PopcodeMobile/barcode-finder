//
//  GetBarcodeFromImage.swift
//  barcode_finder
//
//  Created by Rafael Aquila on 25/12/20.
//

import Foundation

func getBarcodeFromImage(uiImage: UIImage) -> String?{
    let scanners = [scanUsingZxing, scanUsingZBar]
    for scanner in scanners{
        if let barcodeFound = scanner(uiImage){
            return barcodeFound
        }
    }
    return nil
}


private func scanUsingZxing(_ image: UIImage) ->String?{
    let result: String? = zxingScanImage(image)
    if let barcode = result{
        if(!barcode.isEmpty){
            print("ZXing: barcode found - \(barcode)")
            return barcode
        }
    }
    print("ZXing: barcode not found")
    return nil
}

private func scanUsingZBar(_ image: UIImage) ->String?{
    let result: String? = zbarScanImage(image)
    if let barcode = result{
        if(!barcode.isEmpty){
            print("ZBar: barcode found - \(barcode)")
            return barcode
        }
    }
    print("ZBar: barcode not found")
    return nil
}

