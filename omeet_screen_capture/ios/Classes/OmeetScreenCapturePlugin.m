#import "OmeetScreenCapturePlugin.h"
#if __has_include(<omeet_screen_capture/omeet_screen_capture-Swift.h>)
#import <omeet_screen_capture/omeet_screen_capture-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "omeet_screen_capture-Swift.h"
#endif

@implementation OmeetScreenCapturePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftOmeetScreenCapturePlugin registerWithRegistrar:registrar];
}
@end
