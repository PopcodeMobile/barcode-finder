//
//  URLPdf+Conversions.swift
//  iosbarcodefrompdf
//
//  Created by Rafael Aquila on 01/12/20.
//

import Foundation
extension URL {

    func pdfToUIImage(scaleFactor scale:CGFloat = 1.0, pdfPage: Int = 1) -> UIImage? {
        guard let document = CGPDFDocument(self as CFURL) else { return nil }
        guard let page = document.page(at: pdfPage) else { return nil }
        
        let pageRect = page.getBoxRect(.mediaBox)
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: pageRect.size.width * scale, height: pageRect.size.height * scale))
        let img1 = renderer.pngData( actions: { cnv in
            UIColor.white.set()
            
            cnv.fill(pageRect)
            cnv.cgContext.translateBy(x: 0.0, y: pageRect.size.height);
            cnv.cgContext.scaleBy(x: scale, y: -scale);
            cnv.cgContext.drawPDFPage(page);

                })
            let img2 = UIImage(data: img1)
            return img2
    }
}
