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
    if (![CheatController sharedInstance].espEnabled) return;

    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) return;
    CGContextClearRect(context, rect);

    MemoryReader *reader = [MemoryReader sharedInstance];
    if (!reader.isConnected) {
        // Thử attach liên tục vào Free Fire
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

    // Vẽ Watermark / Radar đếm số địch
    int enemyCount = 0;
    
    for (int i = 0; i < count && i < 60; i++) {
        uintptr_t player = [reader readPointer:items + 0x20 + (i * 0x8)];
        if (player == 0) continue;

        uint32_t isDead = [reader readUInt32:player + kOffsets.Player_IsDead];
        if (isDead != 0) continue;

        enemyCount++;

        // Tính vị trí màn hình từ Memory (Transform & XPose)
        uintptr_t xpose = [reader readPointer:player + kOffsets.XPose];
        if (xpose == 0) continue;

        float posX = [reader readFloat:xpose + 0x30];
        float posY = [reader readFloat:xpose + 0x34];
        float posZ = [reader readFloat:xpose + 0x38];

        // Demo vẽ Box ESP lên các toạ độ tìm thấy
        if (posX != 0 || posY != 0) {
            // Giả lập toạ độ màn hình tương đối
            CGFloat screenX = (rect.size.width / 2.0) + (posX * 5.0);
            CGFloat screenY = (rect.size.height / 2.0) - (posY * 5.0);
            CGFloat boxW = 50.0;
            CGFloat boxH = 100.0;

            CGRect boxRect = CGRectMake(screenX - boxW/2, screenY - boxH/2, boxW, boxH);

            // Vẽ Box ESP màu đỏ
            CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
            CGContextSetLineWidth(context, 1.5);
            CGContextAddRect(context, boxRect);
            CGContextStrokePath(context);

            // Vẽ Line nối từ trên xuống đầu địch (Snaplines)
            CGContextMoveToPoint(context, rect.size.width / 2.0, 40);
            CGContextAddLineToPoint(context, screenX, screenY - boxH/2);
            CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
            CGContextSetLineWidth(context, 1.0);
            CGContextStrokePath(context);
        }
    }

    // Hiển thị đếm số địch góc màn hình
    UIFont *font = [UIFont boldSystemFontOfSize:14.0];
    NSDictionary *attr = @{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor greenColor]};
    NSString *statusText = [NSString stringWithFormat:@"[FFExternal] Game Connected | Enemies: %d", enemyCount];
    [statusText drawAtPoint:CGPointMake(20, 40) withAttributes:attr];
}

@end
