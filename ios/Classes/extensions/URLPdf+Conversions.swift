//
//  URLPdf+Conversions.swift
//  iosbarcodefrompdf
//
//  Created by Rafael Aquila on 01/12/20.
//

import Foundation
extension URL {
    
    func pdfPagesToImages(scaleFactor scale:CGFloat = 4.17) -> Array<UIImage>? {
        guard let document = CGPDFDocument(self as CFURL) else { return nil }
        guard let page = document.page(at: 1) else { return nil }
        let page2 = document.page(at: 2)
        
        let page1Image = createUIImageFrom(pdfPage: page, scale: scale)
        let page2Image = createUIImageFrom(pdfPage: page2, scale: scale)
        if page2Image == nil{
            return [page1Image!]

        }
        return [page1Image!, page2Image!]

        
    }
    
    
    private func createUIImageFrom(pdfPage: CGPDFPage?, scale: CGFloat) -> UIImage?{
        if pdfPage == nil {
            return nil
        }
        let pageRect = pdfPage!.getBoxRect(.mediaBox)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: pageRect.size.width * scale, height: pageRect.size.height * scale), format:format)
        let img = renderer.jpegData(withCompressionQuality: 1.0 ,actions: { cnv in
            cnv.cgContext.saveGState()
            UIColor.white.set()
            cnv.fill(pageRect)
            cnv.cgContext.translateBy(x: 0.0, y: pageRect.size.height * scale);
            cnv.cgContext.scaleBy(x: scale, y: -scale);
            cnv.cgContext.concatenate(pdfPage!.getDrawingTransform(.mediaBox, rect: pageRect, rotate: 0, preserveAspectRatio: true))
            cnv.cgContext.drawPDFPage(pdfPage!);
            cnv.cgContext.restoreGState()
        })
        
        return UIImage(data: img)
    }
    
}
