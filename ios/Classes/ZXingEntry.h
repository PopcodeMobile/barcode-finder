//
//  ZXingEntry.h
//  iosbarcodefrompdf
//
//  Created by Rafael Aquila on 30/11/20.
//

#import <Foundation/Foundation.h>
#import "CoreGraphics/CoreGraphics.h"
#import <ZXingObjC/ZXingObjC.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXingEntry : NSObject

+ (ZXResult*) decodeBarcodeFromImage:(UIImage*)imageRef;

@end

NS_ASSUME_NONNULL_END
