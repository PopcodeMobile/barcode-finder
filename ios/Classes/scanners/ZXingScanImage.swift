//
//  ZXingScanImage.swift
//  barcode_finder
//
//  Created by Rafael Aquila on 25/12/20.
//

import Foundation
import ZXingObjC

func zxingScanImage(_ image: UIImage, barcodesToFilter: [BarcodeFormatType]) -> String? {
    let source: ZXLuminanceSource = ZXCGImageLuminanceSource(cgImage: image.cgImage!)
    guard let bitmap = ZXBinaryBitmap(binarizer: ZXHybridBinarizer(source: source)),
          let hints = createZxingHintsFor(barcodeTypes: barcodesToFilter),
          let reader = ZXMultiFormatReader.reader() as? ZXMultiFormatReader,
          let result = try? reader.decode(bitmap, hints: hints) else {
        return nil
    }
    return result.text
}

private func mapBarcodeFormatTypeToZxingFormat(_ barcodeType: BarcodeFormatType) -> ZXBarcodeFormat?{
    switch barcodeType {
    case .any: return nil
    case .upcA:
        return kBarcodeFormatUPCA
    case .upcE:
        return kBarcodeFormatUPCE
    case .ean8:
        return kBarcodeFormatEan8
    case .ean13:
        return kBarcodeFormatEan13
    case .upcEanExtension:
        return kBarcodeFormatUPCEANExtension
    case .code39:
        return kBarcodeFormatCode39
    case .code93:
        return kBarcodeFormatCode93
    case .code128:
        return kBarcodeFormatCode128
    case .codabar:
        return kBarcodeFormatCodabar
    case .itf:
        return kBarcodeFormatITF
    case .qr:
        return kBarcodeFormatQRCode
    case .dataMatrix:
        return kBarcodeFormatDataMatrix
    case .aztec:
        return kBarcodeFormatAztec
    case .pdf417:
        return kBarcodeFormatPDF417
    case .maxicode:
        return kBarcodeFormatMaxiCode
    case .rss14:
        return kBarcodeFormatRSS14
    case .rssexpanded:
        return kBarcodeFormatRSSExpanded
    }
}

private func createZxingHintsFor(barcodeTypes: [BarcodeFormatType]) ->ZXDecodeHints?{
    let hints = ZXDecodeHints()
    for barcodeType in barcodeTypes{
        if(barcodeType == .any){
            return allFormatsZxingHints()
        }
        if let zxingFormat = mapBarcodeFormatTypeToZxingFormat(barcodeType) {
            hints.addPossibleFormat(zxingFormat)
        }
        
    }
    hints.tryHarder = true
    hints.pureBarcode = false
    return hints
}

private func allFormatsZxingHints() -> ZXDecodeHints {
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



