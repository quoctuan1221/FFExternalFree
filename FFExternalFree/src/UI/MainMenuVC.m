#import "MainMenuVC.h"
#import "../Features/CheatController.h"
#import "../Features/ESPOverlayView.h"

@interface MainMenuVC ()
@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, strong) UIButton *floatingIcon;
@property (nonatomic, strong) UIView *startCardView;
@property (nonatomic, assign) BOOL isMenuVisible;
@end

@implementation MainMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];

    self.isMenuVisible = NO;

    [self setupStartScreen];
    [self setupFloatingIcon];
    [self setupMainMenuView];
}

#pragma mark - 1. Màn hình Start ban đầu (Chỉ 1 nút duy nhất)
- (void)setupStartScreen {
    self.startCardView = [[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 240)/2, 200, 240, 140)];
    self.startCardView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.9];
    self.startCardView.layer.cornerRadius = 16;
    self.startCardView.layer.borderColor = [UIColor cyanColor].CGColor;
    self.startCardView.layer.borderWidth = 1.5;
    [self.view addSubview:self.startCardView];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 220, 30)];
    titleLabel.text = @"FFExternal Free";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.startCardView addSubview:titleLabel];

    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startButton.frame = CGRectMake(30, 70, 180, 44);
    startButton.backgroundColor = [UIColor cyanColor];
    [startButton setTitle:@"🚀 START CHEAT" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    startButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    startButton.layer.cornerRadius = 22;
    [startButton addTarget:self action:@selector(onStartClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.startCardView addSubview:startButton];
}

- (void)onStartClicked {
    // Ẩn màn hình Start
    [UIView animateWithDuration:0.3 animations:^{
        self.startCardView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.startCardView removeFromSuperview];
    }];

    // Khởi động cheat & ESP engine
    [[CheatController sharedInstance] startLoop];
    [[ESPOverlayView sharedInstance] showOverlay];

    // Hiện Nút Icon Tròn trôi nổi
    self.floatingIcon.hidden = NO;
    self.floatingIcon.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:0 animations:^{
        self.floatingIcon.transform = CGAffineTransformIdentity;
    } completion:nil];
}

#pragma mark - 2. Floating Icon (Logo Tròn Kéo Thả)
- (void)setupFloatingIcon {
    self.floatingIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    self.floatingIcon.frame = CGRectMake(30, 150, 50, 50);
    self.floatingIcon.backgroundColor = [UIColor colorWithRed:0.1 green:0.7 blue:1.0 alpha:0.95];
    [self.floatingIcon setTitle:@"⚡" forState:UIControlStateNormal];
    self.floatingIcon.titleLabel.font = [UIFont systemFontOfSize:26];
    self.floatingIcon.layer.cornerRadius = 25;
    self.floatingIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    self.floatingIcon.layer.borderWidth = 2.0;
    self.floatingIcon.layer.shadowColor = [UIColor cyanColor].CGColor;
    self.floatingIcon.layer.shadowOffset = CGSizeZero;
    self.floatingIcon.layer.shadowRadius = 8;
    self.floatingIcon.layer.shadowOpacity = 0.8;
    self.floatingIcon.hidden = YES; // Ẩn mặc định cho tới khi ấn Start

    [self.floatingIcon addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];

    // Thêm Cử chỉ Kéo thả (Pan Gesture)
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self selector:@selector(handlePan:)];
    [self.floatingIcon addGestureRecognizer:pan];

    [self.view addSubview:self.floatingIcon];
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:self.view];
    pan.view.center = CGPointMake(pan.view.center.x + translation.x, pan.view.center.y + translation.y);
    [pan setTranslation:CGPointZero inView:self.view];
}

#pragma mark - 3. Menu Chính (Ẩn/Hiện khi bấm Floating Icon)
- (void)setupMainMenuView {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.blurView.frame = CGRectMake(50, 100, 280, 420);
    self.blurView.layer.cornerRadius = 20;
    self.blurView.layer.masksToBounds = YES;
    self.blurView.layer.borderColor = [UIColor colorWithRed:0.2 green:0.8 blue:1.0 alpha:0.5].CGColor;
    self.blurView.layer.borderWidth = 1.5;
    self.blurView.alpha = 0.0;
    self.blurView.hidden = YES;
    [self.view addSubview:self.blurView];

    // Title Label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 240, 30)];
    titleLabel.text = @"⚡ MENU CHEAT ⚡";
    titleLabel.textColor = [UIColor cyanColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.blurView.contentView addSubview:titleLabel];

    // TẤT CẢ TÍNH NĂNG MẶC ĐỊNH TẮT (OFF)
    [self addToggleWithTitle:@"ESP Box & Bones" y:65 selector:@selector(toggleESP:) defaultOn:NO];
    [self addToggleWithTitle:@"Aimbot / Silent Aim" y:115 selector:@selector(toggleAimbot:) defaultOn:NO];
    [self addToggleWithTitle:@"No Recoil" y:165 selector:@selector(toggleNoRecoil:) defaultOn:NO];
    [self addToggleWithTitle:@"No Reload" y:215 selector:@selector(toggleNoReload:) defaultOn:NO];
    [self addToggleWithTitle:@"Speed Hack 2x" y:265 selector:@selector(toggleSpeed:) defaultOn:NO];
    [self addToggleWithTitle:@"Gravity Hack" y:315 selector:@selector(toggleGravity:) defaultOn:NO];

    // Nút Đóng Menu
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(20, 365, 240, 36);
    closeBtn.backgroundColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.3 alpha:0.8];
    [closeBtn setTitle:@"Đóng Menu" forState:UIControlStateNormal];
    closeBtn.layer.cornerRadius = 10;
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    [closeBtn addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.blurView.contentView addSubview:closeBtn];
}

- (void)toggleMenu {
    self.isMenuVisible = !self.isMenuVisible;
    if (self.isMenuVisible) {
        self.blurView.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.blurView.alpha = 1.0;
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.blurView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.blurView.hidden = YES;
        }];
    }
}

- (void)addToggleWithTitle:(NSString *)title y:(CGFloat)y selector:(SEL)selector defaultOn:(BOOL)defaultOn {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 160, 30)];
    label.text = title;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [self.blurView.contentView addSubview:label];

    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(195, y, 60, 30)];
    sw.on = defaultOn;
    sw.onTintColor = [UIColor cyanColor];
    [sw addTarget:self action:selector forControlEvents:UIControlEventValueChanged];
    [self.blurView.contentView addSubview:sw];
}

- (void)toggleESP:(UISwitch *)sender {
    [CheatController sharedInstance].espEnabled = sender.isOn;
}

- (void)toggleAimbot:(UISwitch *)sender {
    [CheatController sharedInstance].aimbotEnabled = sender.isOn;
}

- (void)toggleNoRecoil:(UISwitch *)sender {
    [CheatController sharedInstance].noRecoilEnabled = sender.isOn;
}

- (void)toggleNoReload:(UISwitch *)sender {
    [CheatController sharedInstance].noReloadEnabled = sender.isOn;
}

- (void)toggleSpeed:(UISwitch *)sender {
    [CheatController sharedInstance].speedEnabled = sender.isOn;
}

- (void)toggleGravity:(UISwitch *)sender {
    [CheatController sharedInstance].gravityEnabled = sender.isOn;
}

@end
