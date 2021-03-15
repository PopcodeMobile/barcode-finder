#import "BarcodeFinderPlugin.h"
#if __has_include(<barcode_finder/barcode_finder-Swift.h>)
#import <barcode_finder/barcode_finder-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "barcode_finder-Swift.h"
#endif

@implementation BarcodeFinderPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBarcodeFinderPlugin registerWithRegistrar:registrar];
}
@end
