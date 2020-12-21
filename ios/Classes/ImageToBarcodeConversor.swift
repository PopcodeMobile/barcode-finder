//
//  ImageToBarcodeConversor.swift
//  barcode_finder
//
//  Created by Rafael Aquila on 11/12/20.
//

import Foundation

import Foundation

class ImageToBarcodeConversor {
    
    var image: UIImage?
    let defaultScaleFactor: CGFloat = 3.0
    func tryDecodeBarcodeFromFileImage(imageUrl url: URL, tryOnlyOnce: Bool = true) -> ZXResult?{
        let uiImage = UIImage.init(contentsOfFile: url.path)
               if uiImage == nil{
                   return nil
               }
        self.image = uiImage
        let attemptResult = tryDecode(uiImage: uiImage!, tryOnlyOnce: tryOnlyOnce)
        if attemptResult != nil{
            return attemptResult
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
        attemptTransformList.append(decodeUnmodifiedCurrentImage)
        attemptTransformList.append(decodeCroppedImage)
        attemptTransformList.append(decodeFirstScaledImage)
        attemptTransformList.append(decodeSecondScaledImage)


        
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
    
    private func decodeUnmodifiedCurrentImage() ->ZXResult{
        return  ZXingEntry.decodeBarcode(from: self.image!)
    }
    
    
    
    private func decodeFirstScaledImage() ->ZXResult{
        let scaled = self.image!.scaleToSize(size: CGSize(width: self.image!.size.width * self.defaultScaleFactor, height: self.image!.size.height * self.defaultScaleFactor))!
        self.image = scaled
        return  ZXingEntry.decodeBarcode(from: scaled)
    }
    
    private func decodeSecondScaledImage() ->ZXResult{
        let scaled = self.image!.scaleToSize(size: CGSize(width: self.image!.size.width * self.defaultScaleFactor * 2, height: self.image!.size.height * self.defaultScaleFactor * 2))!
        self.image = scaled
        return  ZXingEntry.decodeBarcode(from: scaled)
    }
    

    
    private func decodeCroppedImage() ->ZXResult{
        let scaleAndCropped = self.image!.cropHalf()
        self.image = scaleAndCropped
        return  ZXingEntry.decodeBarcode(from: scaleAndCropped)
    }
    
    
}

