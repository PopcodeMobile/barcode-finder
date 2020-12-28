//
//  ZXingScanImage.swift
//  barcode_finder
//
//  Created by Rafael Aquila on 25/12/20.
//

import Foundation
import ZXingObjC

func zxingScanImage(_ image: UIImage, barcodeType: BarcodeFormatType = .any) -> String? {
    let source: ZXLuminanceSource = ZXCGImageLuminanceSource(cgImage: image.cgImage!)
    guard let bitmap = ZXBinaryBitmap(binarizer: ZXHybridBinarizer(source: source)),
          let hints = createHints(barcodeType),
          let reader = ZXMultiFormatReader.reader() as? ZXMultiFormatReader,
          let result = try? reader.decode(bitmap, hints: hints) else {
        return nil
    }
    return result.text
}

private func createHints(_ barcodeType: BarcodeFormatType) -> ZXDecodeHints? {
    if(barcodeType == .any){
        return allFormatsHints()
    }
    // TODO: Map others BarcodeFormatType to ZXBarcodeFormat
    return  allFormatsHints()
    
}

private func allFormatsHints() -> ZXDecodeHints {
    let hints = ZXDecodeHints()
    hints.addPossibleFormat(kBarcodeFormatCodabar)
    hints.addPossibleFormat(kBarcodeFormatQRCode)
    hints.addPossibleFormat(kBarcodeFormatMaxiCode)
    hints.addPossibleFormat(kBarcodeFormatDataMatrix)
    hints.addPossibleFormat(kBarcodeFormatITF)
    hints.addPossibleFormat(kBarcodeFormatEan8)
    hints.addPossibleFormat(kBarcodeFormatEan13)
    hints.addPossibleFormat(kBarcodeFormatCode128)
    hints.addPossibleFormat(kBarcodeFormatCode93)
    hints.addPossibleFormat(kBarcodeFormatCode39)
    hints.tryHarder = true
    hints.pureBarcode = false
    return hints
}
