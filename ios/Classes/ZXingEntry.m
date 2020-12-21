//
//  ZXingEntry.m
//  iosbarcodefrompdf
//
//  Created by Rafael Aquila on 30/11/20.
//

#import "ZXingEntry.h"

@implementation ZXingEntry


+ (ZXResult*) decodeBarcodeFromImage:(UIImage*)imageRef
{
    ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageRef.CGImage];
    
    ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
    
    NSError *error = nil;
    
    ZXDecodeHints *hints = [ZXDecodeHints hints];
        hints.tryHarder = YES;
        [hints addPossibleFormat:kBarcodeFormatCodabar];
        [hints addPossibleFormat:kBarcodeFormatQRCode];
        [hints addPossibleFormat:kBarcodeFormatITF];
        [hints addPossibleFormat:kBarcodeFormatEan8];
        [hints addPossibleFormat:kBarcodeFormatEan13];
        [hints addPossibleFormat:kBarcodeFormatCode128];
        [hints addPossibleFormat:kBarcodeFormatCode93];
        [hints addPossibleFormat:kBarcodeFormatCode39];



         hints.pureBarcode = NO;

    ZXMultiFormatOneDReader *reader = [[ZXMultiFormatOneDReader alloc] initWithHints:hints];
    
    ZXResult *result = [reader decode:bitmap
                                hints:hints
                                error:&error];
    if (result) {
       return result;
    }else{
        return nil;
    }
    
}


@end
