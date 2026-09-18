#import <UIKit/UIKit.h>

@interface ESPOverlayView : UIView

+ (instancetype)sharedInstance;
- (void)showOverlay;
- (void)hideOverlay;

@end
