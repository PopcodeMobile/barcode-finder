//
//  PDFtoBarcodeConversor.swift
//  iosbarcodefrompdf
//
//  Created by Rafael Aquila on 01/12/20.
//

import Foundation

class PDFToBarcodeConversor {
    
    var image: UIImage?
    var url: URL?
    let defaultScaleFactor: CGFloat = 3.0
    func tryDecodeBarcodeFromPDF(pdfUrl url: URL, tryOnlyOnce: Bool = true) -> ZXResult?{
        let uiImageFirstPage = url.pdfToUIImage()
               if uiImageFirstPage == nil{
                   return nil
               }
        self.image = uiImageFirstPage
        self.url = url
        
        let firstPageAttemptResult = tryDecode(uiImage: uiImageFirstPage!, tryOnlyOnce: tryOnlyOnce)
        if firstPageAttemptResult != nil{
            return firstPageAttemptResult
        }
        
        let uiImageSecondPage = url.pdfToUIImage(scaleFactor: 1.0, pdfPage: 2)
               if uiImageSecondPage == nil{
                   return nil
               }
        self.image = uiImageSecondPage
        let secondPageAttemptResult = tryDecode(uiImage: uiImageFirstPage!, tryOnlyOnce: tryOnlyOnce)
        if secondPageAttemptResult != nil{
            return secondPageAttemptResult
        }
        
        
        return nil

    }
    
    private func tryDecode(uiImage: UIImage, tryOnlyOnce: Bool) -> ZXResult?{
        let rotationAttemptResult = tryRotateImage()
        if rotationAttemptResult != nil{
            return rotationAttemptResult
        }
        if tryOnlyOnce{
            return nil
        }
        self.image = uiImage

        let transformAttemptResult = tryTransformImage()
        if transformAttemptResult != nil{
            return transformAttemptResult
        }
        
        return nil
    }
    
    private func tryRotateImage() -> ZXResult?{
        let attemptRotationsList = createRotationAttemptList()
        for attempFunction in attemptRotationsList{
            if let result = attempFunction(self.image!){
                if(!result.text.isEmpty){
                    return result
                }
            }
        }
        return nil;
    }
    
    private func tryTransformImage() -> ZXResult?{
        let attemptTransformList = createTransformAttemptList()
        for attempFunction in attemptTransformList{
            if let result = attempFunction(){
                if(!result.text.isEmpty){
                    return result
                }
            }
        }
        return nil
    }
    
    private func createRotationAttemptList() -> Array<((UIImage) ->ZXResult?)> {
        var attemptRotationsList = Array<((UIImage) ->ZXResult?)>()
        attemptRotationsList.append(decodeUnmodifiedImage)
        attemptRotationsList.append(decodeRotated90DegreesImage)
        attemptRotationsList.append(decodeRotated90DegreesImage)
        attemptRotationsList.append(decodeRotated90DegreesImage)
        return attemptRotationsList
    }
    
    private func createTransformAttemptList() -> Array<(() ->ZXResult?)> {
        var attemptTransformList = Array<(() ->ZXResult?)>()
        attemptTransformList.append(decodeUnmodifiedPdf)
        attemptTransformList.append(decodeCroppedPdf)
        attemptTransformList.append(decodeFirstScaledPdf)
        attemptTransformList.append(decodeSecondScaledPdf)


        
        return attemptTransformList
    }
    
    private func decodeUnmodifiedImage(uiImage: UIImage) ->ZXResult?{
        return  ZXingEntry.decodeBarcode(from: uiImage)
    }
    
    private func decodeRotated90DegreesImage(uiImage: UIImage) ->ZXResult{
        let rotated = uiImage.rotate(radians: .pi/2)
        self.image = rotated
        return  ZXingEntry.decodeBarcode(from: rotated!)
    }
    
    private func decodeUnmodifiedPdf() ->ZXResult{
        return  ZXingEntry.decodeBarcode(from: self.image!)
    }
    
    
    
    private func decodeFirstScaledPdf() ->ZXResult{
        let scaled = self.url!.pdfToUIImage(scaleFactor: self.defaultScaleFactor)!
        self.image = scaled
        return  ZXingEntry.decodeBarcode(from: scaled)
    }
    
    private func decodeSecondScaledPdf() ->ZXResult{
        let scaled = self.url!.pdfToUIImage(scaleFactor: self.defaultScaleFactor * 2)!
        self.image = scaled
        return  ZXingEntry.decodeBarcode(from: scaled)
    }
    

    
    private func decodeCroppedPdf() ->ZXResult{
        let scaleAndCropped = self.image!.cropHalf()
        self.image = scaleAndCropped
        return  ZXingEntry.decodeBarcode(from: scaleAndCropped)
    }
    
    
}

