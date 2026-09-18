#import "ESPOverlayView.h"
#import "CheatController.h"
#import "../Memory/MemoryReader.h"

@interface ESPOverlayView ()
@property (nonatomic, strong) CADisplayLink *displayLink;
@end

@implementation ESPOverlayView

+ (instancetype)sharedInstance {
    static ESPOverlayView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGRect frame = [UIScreen mainScreen].bounds;
        instance = [[ESPOverlayView alloc] initWithFrame:frame];
    });
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO; // Cho phép touch xuyên qua!
        self.layer.masksToBounds = NO;

        // Đăng ký nhận sự kiện quay màn hình để tự ẩn (Anti-Ban/Anti-Recorder)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenCaptureChanged) name:UIScreenCapturedDidChangeNotification object:nil];
    }
    return self;
}

- (void)screenCaptureChanged {
    if ([UIScreen mainScreen].isCaptured) {
        self.hidden = YES; // Tự ẩn khi bị quay màn hình
    } else {
        self.hidden = NO;
    }
}

- (void)showOverlay {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (keyWindow && !self.superview) {
        [keyWindow addSubview:self];
    }
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateDraw)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)hideOverlay {
    [self.displayLink invalidate];
    self.displayLink = nil;
    [self removeFromSuperview];
}

- (void)updateDraw {
    if ([CheatController sharedInstance].espEnabled) {
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) return;
    CGContextClearRect(context, rect);

    MemoryReader *reader = [MemoryReader sharedInstance];
    if (!reader.isConnected) return;

    // Demo ESP UI Indicator khi đã đính kèm vào game thành công
    UIFont *font = [UIFont boldSystemFontOfSize:14.0];
    NSDictionary *attr = @{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor greenColor]};
    NSString *statusText = @"[FFExternalFree] Status: ACTIVE | Anti-Ban: ON";
    [statusText drawAtPoint:CGPointMake(20, 40) withAttributes:attr];
}

@end
