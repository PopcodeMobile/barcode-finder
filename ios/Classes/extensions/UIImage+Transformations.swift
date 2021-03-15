//
//  UIImage+Transformations.swift
//  iosbarcodefrompdf
//
//  Created by Rafael Aquila on 01/12/20.
//

import Foundation


extension UIImage{
    
    func cropHalf() -> UIImage{
        let height = CGFloat(self.size.height / 2)
            let rect = CGRect(x: 0, y: self.size.height - height, width: self.size.width, height: height)
        let imageRef:CGImage = self.cgImage!.cropping(to: rect)!
            let croppedImage:UIImage = UIImage(cgImage:imageRef)
        
        
            return croppedImage
    }
    
    
    func rotate(radians: Float) -> UIImage? {
            var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
            newSize.width = floor(newSize.width)
            newSize.height = floor(newSize.height)

            UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
            let context = UIGraphicsGetCurrentContext()!

            context.translateBy(x: newSize.width/2, y: newSize.height/2)
            context.rotate(by: CGFloat(radians))
            self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return newImage
        }

    
}
