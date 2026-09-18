#import "MainMenuVC.h"
#import "../Features/CheatController.h"
#import "../Features/ESPOverlayView.h"

@interface MainMenuVC ()
@property (nonatomic, strong) UIView *menuContainerView;
@property (nonatomic, strong) UIButton *floatingIcon;
@property (nonatomic, strong) UIView *startCardView;
@property (nonatomic, assign) BOOL isMenuVisible;
@property (nonatomic, assign) NSInteger currentTabIndex; // 0: Esp, 1: Aimbot, 2: Other

@property (nonatomic, strong) UIView *contentScrollView;
@property (nonatomic, strong) UIButton *tabEspBtn;
@property (nonatomic, strong) UIButton *tabAimbotBtn;
@property (nonatomic, strong) UIButton *tabOtherBtn;
@property (nonatomic, strong) UILabel *aimSpeedValLabel;
@property (nonatomic, strong) UILabel *circleSizeValLabel;
@end

@implementation MainMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.isMenuVisible = NO;
    self.currentTabIndex = 0;

    [self setupStartScreen];
    [self setupFloatingIcon];
    [self setupMainMenuView];
}

#pragma mark - 1. Màn hình Start ban đầu
- (void)setupStartScreen {
    self.startCardView = [[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 240)/2, 200, 240, 140)];
    self.startCardView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.95];
    self.startCardView.layer.cornerRadius = 16;
    self.startCardView.layer.borderColor = [UIColor colorWithRed:0.2 green:0.8 blue:1.0 alpha:0.8].CGColor;
    self.startCardView.layer.borderWidth = 1.5;
    [self.view addSubview:self.startCardView];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 220, 30)];
    titleLabel.text = @"Zoro External";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.startCardView addSubview:titleLabel];

    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startButton.frame = CGRectMake(30, 70, 180, 44);
    startButton.backgroundColor = [UIColor colorWithRed:0.2 green:0.8 blue:1.0 alpha:1.0];
    [startButton setTitle:@"🚀 START CHEAT" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    startButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    startButton.layer.cornerRadius = 22;
    [startButton addTarget:self action:@selector(onStartClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.startCardView addSubview:startButton];
}

- (void)onStartClicked {
    [UIView animateWithDuration:0.3 animations:^{
        self.startCardView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.startCardView removeFromSuperview];
    }];

    [[CheatController sharedInstance] startLoop];
    [[ESPOverlayView sharedInstance] showOverlay];

    self.floatingIcon.hidden = NO;
    self.floatingIcon.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:0 animations:^{
        self.floatingIcon.transform = CGAffineTransformIdentity;
    } completion:nil];
}

#pragma mark - 2. Floating Icon
- (void)setupFloatingIcon {
    self.floatingIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    self.floatingIcon.frame = CGRectMake(30, 150, 48, 48);
    self.floatingIcon.backgroundColor = [UIColor whiteColor];
    [self.floatingIcon setTitle:@"⚔️" forState:UIControlStateNormal];
    self.floatingIcon.titleLabel.font = [UIFont systemFontOfSize:24];
    self.floatingIcon.layer.cornerRadius = 24;
    self.floatingIcon.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
    self.floatingIcon.layer.borderWidth = 1.5;
    self.floatingIcon.layer.shadowColor = [UIColor blackColor].CGColor;
    self.floatingIcon.layer.shadowOffset = CGSizeMake(0, 3);
    self.floatingIcon.layer.shadowRadius = 6;
    self.floatingIcon.layer.shadowOpacity = 0.3;
    self.floatingIcon.hidden = YES;

    [self.floatingIcon addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.floatingIcon addGestureRecognizer:pan];

    [self.view addSubview:self.floatingIcon];
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:self.view];
    pan.view.center = CGPointMake(pan.view.center.x + translation.x, pan.view.center.y + translation.y);
    [pan setTranslation:CGPointZero inView:self.view];
}

#pragma mark - 3. Zoro Style Menu (Trắng bo góc + 3 Tabs + Sliders)
- (void)setupMainMenuView {
    CGFloat width = 310;
    CGFloat height = 430;

    self.menuContainerView = [[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - width)/2, 60, width, height)];
    self.menuContainerView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:0.98];
    self.menuContainerView.layer.cornerRadius = 20;
    self.menuContainerView.layer.masksToBounds = YES;
    self.menuContainerView.alpha = 0.0;
    self.menuContainerView.hidden = YES;
    [self.view addSubview:self.menuContainerView];

    // Header Title "Zoro"
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, width, 26)];
    headerLabel.text = @"Zoro";
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:19];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    [self.menuContainerView addSubview:headerLabel];

    // Close Button "✕"
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(width - 38, 12, 28, 28);
    [closeBtn setTitle:@"✕" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    [closeBtn addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.menuContainerView addSubview:closeBtn];

    // Segmented Tabs Header
    UIView *tabHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 48, width, 40)];
    tabHeader.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.0];
    [self.menuContainerView addSubview:tabHeader];

    CGFloat tabW = width / 3.0;
    self.tabEspBtn = [self createTabButtonWithTitle:@"Esp" frame:CGRectMake(0, 0, tabW, 40) tag:0];
    self.tabAimbotBtn = [self createTabButtonWithTitle:@"Aimbot" frame:CGRectMake(tabW, 0, tabW, 40) tag:1];
    self.tabOtherBtn = [self createTabButtonWithTitle:@"Other" frame:CGRectMake(tabW*2, 0, tabW, 40) tag:2];

    [tabHeader addSubview:self.tabEspBtn];
    [tabHeader addSubview:self.tabAimbotBtn];
    [tabHeader addSubview:self.tabOtherBtn];

    // Content View
    self.contentScrollView = [[UIView alloc] initWithFrame:CGRectMake(0, 88, width, height - 88 - 30)];
    [self.menuContainerView addSubview:self.contentScrollView];

    // Footer
    UILabel *footerLeft = [[UILabel alloc] initWithFrame:CGRectMake(12, height - 26, 120, 20)];
    footerLeft.text = @"FF: External";
    footerLeft.textColor = [UIColor grayColor];
    footerLeft.font = [UIFont systemFontOfSize:11];
    [self.menuContainerView addSubview:footerLeft];

    UILabel *footerRight = [[UILabel alloc] initWithFrame:CGRectMake(width - 132, height - 26, 120, 20)];
    footerRight.text = @"Free Fire";
    footerRight.textColor = [UIColor grayColor];
    footerRight.font = [UIFont systemFontOfSize:11];
    footerRight.textAlignment = NSTextAlignmentRight;
    [self.menuContainerView addSubview:footerRight];

    [self selectTabAtIndex:0];
}

- (UIButton *)createTabButtonWithTitle:(NSString *)title frame:(CGRect)frame tag:(NSInteger)tag {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    btn.tag = tag;
    [btn addTarget:self action:@selector(onTabSelected:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)onTabSelected:(UIButton *)sender {
    [self selectTabAtIndex:sender.tag];
}

- (void)selectTabAtIndex:(NSInteger)index {
    self.currentTabIndex = index;

    self.tabEspBtn.backgroundColor = [UIColor clearColor];
    self.tabAimbotBtn.backgroundColor = [UIColor clearColor];
    self.tabOtherBtn.backgroundColor = [UIColor clearColor];

    [self.tabEspBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.tabAimbotBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.tabOtherBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

    if (index == 0) {
        self.tabEspBtn.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
        [self.tabEspBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self renderEspTab];
    } else if (index == 1) {
        self.tabAimbotBtn.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
        [self.tabAimbotBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self renderAimbotTab];
    } else {
        self.tabOtherBtn.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
        [self.tabOtherBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self renderOtherTab];
    }
}

#pragma mark - Render Tab Contents
- (void)renderEspTab {
    for (UIView *sub in self.contentScrollView.subviews) [sub removeFromSuperview];

    CheatController *cheat = [CheatController sharedInstance];
    CGFloat y = 10;

    [self addSectionHeader:@"Switch" y:y]; y += 24;

    [self addRowToggle:@"Enable Esp" isOn:cheat.espEnabled y:y action:@selector(onEspToggle:)]; y += 44;
    [self addRowToggle:@"Line Esp" isOn:cheat.lineEspEnabled y:y action:@selector(onLineEspToggle:)]; y += 44;
    [self addRowToggle:@"Box Esp" isOn:cheat.boxEspEnabled y:y action:@selector(onBoxEspToggle:)]; y += 44;
    [self addRowToggle:@"Info Esp" isOn:cheat.infoEspEnabled y:y action:@selector(onInfoEspToggle:)]; y += 44;
    [self addRowToggle:@"Bone Esp" isOn:cheat.boneEspEnabled y:y action:@selector(onBoneEspToggle:)]; y += 44;
}

- (void)renderAimbotTab {
    for (UIView *sub in self.contentScrollView.subviews) [sub removeFromSuperview];

    CheatController *cheat = [CheatController sharedInstance];
    CGFloat y = 10;

    [self addSectionHeader:@"Switch" y:y]; y += 24;

    [self addRowToggle:@"Enable Aimbot" isOn:cheat.aimbotEnabled y:y action:@selector(onAimbotToggle:)]; y += 44;
    [self addRowToggle:@"Ignore Knock" isOn:cheat.ignoreKnock y:y action:@selector(onIgnoreKnockToggle:)]; y += 44;
    [self addRowToggle:@"Ignore Bot" isOn:cheat.ignoreBot y:y action:@selector(onIgnoreBotToggle:)]; y += 44;
    [self addRowToggle:@"Aim Wukong" isOn:cheat.aimWukong y:y action:@selector(onAimWukongToggle:)]; y += 44;

    [self addSectionHeader:@"Slider" y:y]; y += 24;

    self.aimSpeedValLabel = [self addRowSlider:@"Aim Speed" value:cheat.aimSpeed min:0 max:100 y:y action:@selector(onAimSpeedSlider:)]; y += 48;
    self.circleSizeValLabel = [self addRowSlider:@"Circle Size" value:cheat.circleSize min:0 max:100 y:y action:@selector(onCircleSizeSlider:)]; y += 48;
}

- (void)renderOtherTab {
    for (UIView *sub in self.contentScrollView.subviews) [sub removeFromSuperview];

    CheatController *cheat = [CheatController sharedInstance];
    CGFloat y = 10;

    [self addSectionHeader:@"Switch" y:y]; y += 24;

    [self addRowToggle:@"No Recoil" isOn:cheat.noRecoilEnabled y:y action:@selector(onNoRecoilToggle:)]; y += 44;
    [self addRowToggle:@"No Reload" isOn:cheat.noReloadEnabled y:y action:@selector(onNoReloadToggle:)]; y += 44;
    [self addRowToggle:@"Speed Hack 2x" isOn:cheat.speedEnabled y:y action:@selector(onSpeedToggle:)]; y += 44;
    [self addRowToggle:@"Gravity Hack" isOn:cheat.gravityEnabled y:y action:@selector(onGravityToggle:)]; y += 44;
}

#pragma mark - Component Helpers
- (void)addSectionHeader:(NSString *)title y:(CGFloat)y {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(16, y, 200, 20)];
    lbl.text = title;
    lbl.textColor = [UIColor darkGrayColor];
    lbl.font = [UIFont boldSystemFontOfSize:12];
    [self.contentScrollView addSubview:lbl];
}

- (void)addRowToggle:(NSString *)title isOn:(BOOL)isOn y:(CGFloat)y action:(SEL)action {
    CGFloat width = self.contentScrollView.bounds.size.width;

    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(16, y + 6, 180, 24)];
    lbl.text = title;
    lbl.textColor = [UIColor blackColor];
    lbl.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [self.contentScrollView addSubview:lbl];

    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(width - 66, y + 2, 50, 30)];
    sw.on = isOn;
    sw.onTintColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.3 alpha:1.0];
    [sw addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    [self.contentScrollView addSubview:sw];
}

- (UILabel *)addRowSlider:(NSString *)title value:(float)value min:(float)min max:(float)max y:(CGFloat)y action:(SEL)action {
    CGFloat width = self.contentScrollView.bounds.size.width;

    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(16, y, 140, 20)];
    lbl.text = title;
    lbl.textColor = [UIColor blackColor];
    lbl.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [self.contentScrollView addSubview:lbl];

    UILabel *valLbl = [[UILabel alloc] initWithFrame:CGRectMake(width - 70, y, 54, 20)];
    valLbl.text = [NSString stringWithFormat:@"%.1f", value];
    valLbl.textColor = [UIColor grayColor];
    valLbl.font = [UIFont systemFontOfSize:12];
    valLbl.textAlignment = NSTextAlignmentRight;
    [self.contentScrollView addSubview:valLbl];

    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(16, y + 20, width - 32, 24)];
    slider.minimumValue = min;
    slider.maximumValue = max;
    slider.value = value;
    slider.minimumTrackTintColor = [UIColor colorWithRed:0.1 green:0.6 blue:1.0 alpha:1.0];
    [slider addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    [self.contentScrollView addSubview:slider];

    return valLbl;
}

#pragma mark - Explicit Actions
- (void)onEspToggle:(UISwitch *)sender { [CheatController sharedInstance].espEnabled = sender.isOn; }
- (void)onLineEspToggle:(UISwitch *)sender { [CheatController sharedInstance].lineEspEnabled = sender.isOn; }
- (void)onBoxEspToggle:(UISwitch *)sender { [CheatController sharedInstance].boxEspEnabled = sender.isOn; }
- (void)onInfoEspToggle:(UISwitch *)sender { [CheatController sharedInstance].infoEspEnabled = sender.isOn; }
- (void)onBoneEspToggle:(UISwitch *)sender { [CheatController sharedInstance].boneEspEnabled = sender.isOn; }

- (void)onAimbotToggle:(UISwitch *)sender { [CheatController sharedInstance].aimbotEnabled = sender.isOn; }
- (void)onIgnoreKnockToggle:(UISwitch *)sender { [CheatController sharedInstance].ignoreKnock = sender.isOn; }
- (void)onIgnoreBotToggle:(UISwitch *)sender { [CheatController sharedInstance].ignoreBot = sender.isOn; }
- (void)onAimWukongToggle:(UISwitch *)sender { [CheatController sharedInstance].aimWukong = sender.isOn; }

- (void)onNoRecoilToggle:(UISwitch *)sender { [CheatController sharedInstance].noRecoilEnabled = sender.isOn; }
- (void)onNoReloadToggle:(UISwitch *)sender { [CheatController sharedInstance].noReloadEnabled = sender.isOn; }
- (void)onSpeedToggle:(UISwitch *)sender { [CheatController sharedInstance].speedEnabled = sender.isOn; }
- (void)onGravityToggle:(UISwitch *)sender { [CheatController sharedInstance].gravityEnabled = sender.isOn; }

- (void)onAimSpeedSlider:(UISlider *)sender {
    [CheatController sharedInstance].aimSpeed = sender.value;
    self.aimSpeedValLabel.text = [NSString stringWithFormat:@"%.1f", sender.value];
}

- (void)onCircleSizeSlider:(UISlider *)sender {
    [CheatController sharedInstance].circleSize = sender.value;
    self.circleSizeValLabel.text = [NSString stringWithFormat:@"%.1f", sender.value];
}

- (void)toggleMenu {
    self.isMenuVisible = !self.isMenuVisible;
    if (self.isMenuVisible) {
        self.menuContainerView.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.menuContainerView.alpha = 1.0;
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.menuContainerView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.menuContainerView.hidden = YES;
        }];
    }
}

@end
