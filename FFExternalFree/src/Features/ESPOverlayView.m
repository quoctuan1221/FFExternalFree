#import "ESPOverlayView.h"
#import "CheatController.h"
#import "../Memory/MemoryReader.h"
#import <math.h>

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

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
    CheatController *cheat = [CheatController sharedInstance];
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) return;
    CGContextClearRect(context, rect);

    // 1. Vẽ FOV Circle nếu Aimbot bật
    if (cheat.aimbotEnabled && cheat.circleSize > 0) {
        CGPoint center = CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0);
        CGFloat radius = cheat.circleSize * 3.0; // scale ra màn hình
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.6].CGColor);
        CGContextSetLineWidth(context, 1.2);
        CGContextAddArc(context, center.x, center.y, radius, 0, M_PI * 2, 0);
        CGContextStrokePath(context);
    }

    if (!cheat.espEnabled) return;

    MemoryReader *reader = [MemoryReader sharedInstance];
    if (!reader.isConnected) {
        [reader attachToProcess:@"FreeFire"];
        return;
    }

    uintptr_t il2cppBase = reader.baseAddress;
    if (il2cppBase == 0) return;

    uintptr_t initBasePtr = [reader readPointer:il2cppBase + kOffsets.InitBase];
    if (initBasePtr == 0) return;

    uintptr_t currentMatch = [reader readPointer:initBasePtr + kOffsets.CurrentMatch];
    if (currentMatch == 0) return;

    uintptr_t entityDict = [reader readPointer:currentMatch + kOffsets.DictionaryEntities];
    if (entityDict == 0) return;

    int count = [reader readInt32:entityDict + 0x18];
    uintptr_t items = [reader readPointer:entityDict + 0x10];

    int enemyCount = 0;
    
    for (int i = 0; i < count && i < 60; i++) {
        uintptr_t player = [reader readPointer:items + 0x20 + (i * 0x8)];
        if (player == 0) continue;

        uint32_t isDead = [reader readUInt32:player + kOffsets.Player_IsDead];
        if (isDead != 0) continue;

        // Skip knock nếu bật ignoreKnock
        if (cheat.ignoreKnock) {
            // Check health hoặc knock state ở đây
        }

        enemyCount++;

        uintptr_t xpose = [reader readPointer:player + kOffsets.XPose];
        if (xpose == 0) continue;

        float posX = [reader readFloat:xpose + 0x30];
        float posY = [reader readFloat:xpose + 0x34];
        float posZ = [reader readFloat:xpose + 0x38];

        if (posX != 0 || posY != 0) {
            CGFloat screenX = (rect.size.width / 2.0) + (posX * 4.5);
            CGFloat screenY = (rect.size.height / 2.0) - (posY * 4.5);
            CGFloat boxW = 45.0;
            CGFloat boxH = 90.0;

            CGRect boxRect = CGRectMake(screenX - boxW/2, screenY - boxH/2, boxW, boxH);

            // 2. Line ESP
            if (cheat.lineEspEnabled) {
                CGContextMoveToPoint(context, rect.size.width / 2.0, 40);
                CGContextAddLineToPoint(context, screenX, screenY - boxH/2);
                CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.2 green:0.9 blue:1.0 alpha:0.8].CGColor);
                CGContextSetLineWidth(context, 1.2);
                CGContextStrokePath(context);
            }

            // 3. Box ESP
            if (cheat.boxEspEnabled) {
                CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:1.0 green:0.2 blue:0.3 alpha:0.9].CGColor);
                CGContextSetLineWidth(context, 1.8);
                CGContextAddRect(context, boxRect);
                CGContextStrokePath(context);
            }

            // 4. Info ESP (Tên / Máu / Khoảng cách)
            if (cheat.infoEspEnabled) {
                UIFont *font = [UIFont systemFontOfSize:11.0 weight:UIFontWeightBold];
                NSDictionary *attr = @{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor whiteColor]};
                NSString *infoStr = [NSString stringWithFormat:@"Enemy [%.0fm]", posZ];
                [infoStr drawAtPoint:CGPointMake(screenX - 25, screenY - boxH/2 - 16) withAttributes:attr];
            }
        }
    }
}

@end
