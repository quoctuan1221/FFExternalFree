#import <UIKit/UIKit.h>
#import "UI/MainMenuVC.h"
#import "Features/ESPOverlayView.h"

@interface OverlayWindow : UIWindow
@end

@implementation OverlayWindow
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    // Touch passthrough: If touching background view, pass touch to game below
    if (hitView == self || hitView == self.rootViewController.view) {
        return nil;
    }
    return hitView;
}
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) OverlayWindow *window;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    CGRect frame = [UIScreen mainScreen].bounds;
    self.window = [[OverlayWindow alloc] initWithFrame:frame];
    
    // Set system window level (Above SpringBoard and All Apps)
    self.window.windowLevel = 1000000.0f; // System Overlay Level
    self.window.backgroundColor = [UIColor clearColor];
    
    MainMenuVC *vc = [[MainMenuVC alloc] init];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Keep window active and visible when going to background/switching to game
    [self.window makeKeyAndVisible];
    self.window.hidden = NO;
}

@end

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
