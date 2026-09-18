#import "MainMenuVC.h"
#import "../Features/CheatController.h"
#import "../Features/ESPOverlayView.h"

@interface MainMenuVC ()
@property (nonatomic, strong) UIVisualEffectView *blurView;
@end

@implementation MainMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];

    [self setupUI];

    // Khởi động cheat loop và ESP overlay
    [[CheatController sharedInstance] startLoop];
    [[ESPOverlayView sharedInstance] showOverlay];
}

- (void)setupUI {
    // Background Dark Blur
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.blurView.frame = CGRectMake(50, 100, 300, 420);
    self.blurView.layer.cornerRadius = 20;
    self.blurView.layer.masksToBounds = YES;
    self.blurView.layer.borderColor = [UIColor colorWithRed:0.2 green:0.8 blue:1.0 alpha:0.5].CGColor;
    self.blurView.layer.borderWidth = 1.5;
    [self.view addSubview:self.blurView];

    // Title Label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 260, 30)];
    titleLabel.text = @"⚡ FFExternal Free ⚡";
    titleLabel.textColor = [UIColor cyanColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.blurView.contentView addSubview:titleLabel];

    // Subtitle (No Key Notice)
    UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 260, 20)];
    subLabel.text = @"VIP License: FREE FOREVER (NO KEY)";
    subLabel.textColor = [UIColor lightGrayColor];
    subLabel.font = [UIFont systemFontOfSize:12];
    subLabel.textAlignment = NSTextAlignmentCenter;
    [self.blurView.contentView addSubview:subLabel];

    // Switches
    [self addToggleWithTitle:@"ESP Box & Bones" y:90 selector:@selector(toggleESP:) defaultOn:YES];
    [self addToggleWithTitle:@"Aimbot / Silent Aim" y:140 selector:@selector(toggleAimbot:) defaultOn:YES];
    [self addToggleWithTitle:@"No Recoil" y:190 selector:@selector(toggleNoRecoil:) defaultOn:YES];
    [self addToggleWithTitle:@"No Reload" y:240 selector:@selector(toggleNoReload:) defaultOn:YES];
    [self addToggleWithTitle:@"Speed Hack 2x" y:290 selector:@selector(toggleSpeed:) defaultOn:NO];
    [self addToggleWithTitle:@"Gravity Hack" y:340 selector:@selector(toggleGravity:) defaultOn:NO];
}

- (void)addToggleWithTitle:(NSString *)title y:(CGFloat)y selector:(SEL)selector defaultOn:(BOOL)defaultOn {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, y, 180, 30)];
    label.text = title;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    [self.blurView.contentView addSubview:label];

    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(215, y, 60, 30)];
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
