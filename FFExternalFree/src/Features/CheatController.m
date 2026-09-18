#import "CheatController.h"

@interface CheatController ()
@property (nonatomic, strong) NSTimer *cheatTimer;
@end

@implementation CheatController

+ (instancetype)sharedInstance {
    static CheatController *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CheatController alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // ESP defaults OFF
        _espEnabled = NO;
        _lineEspEnabled = NO;
        _boxEspEnabled = NO;
        _infoEspEnabled = NO;
        _boneEspEnabled = NO;

        // Aimbot defaults OFF
        _aimbotEnabled = NO;
        _ignoreKnock = NO;
        _ignoreBot = NO;
        _aimWukong = NO;
        _aimSpeed = 50.0f;
        _circleSize = 40.0f;
        _aimModeIndex = 0;
        _aimTargetIndex = 0;
        _aimTypeIndex = 0;

        // Other defaults OFF
        _noRecoilEnabled = NO;
        _noReloadEnabled = NO;
        _speedEnabled = NO;
        _gravityEnabled = NO;
        _speedMultiplier = 2.0f;
    }
    return self;
}

- (void)startLoop {
    if (self.cheatTimer) return;
    self.cheatTimer = [NSTimer scheduledTimerWithTimeInterval:0.016 target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

- (void)stopLoop {
    [self.cheatTimer invalidate];
    self.cheatTimer = nil;
}

- (void)tick {
    MemoryReader *reader = [MemoryReader sharedInstance];
    if (!reader.isConnected) {
        // Thử attach lại nếu chưa kết nối
        [reader attachToProcess:@"FreeFire"];
        return;
    }

    uintptr_t il2cppBase = reader.baseAddress;
    if (il2cppBase == 0) return;

    // Lấy LocalPlayer
    uintptr_t initBasePtr = [reader readPointer:il2cppBase + kOffsets.InitBase];
    if (initBasePtr == 0) return;

    uintptr_t localPlayer = [reader readPointer:initBasePtr + kOffsets.LocalPlayer];
    if (localPlayer == 0) return;

    // 1. Mod No Recoil
    if (self.noRecoilEnabled) {
        uintptr_t weapon = [reader readPointer:localPlayer + kOffsets.Weapon];
        if (weapon != 0) {
            float zeroRecoil = 0.0f;
            [reader writeBytes:weapon + kOffsets.WeaponRecoil buffer:&zeroRecoil size:sizeof(zeroRecoil)];
        }
    }

    // 2. Mod No Reload
    if (self.noReloadEnabled) {
        uintptr_t playerAttr = [reader readPointer:localPlayer + kOffsets.PlayerAttributes];
        if (playerAttr != 0) {
            uint8_t noReloadVal = 1;
            [reader writeBytes:playerAttr + kOffsets.NoReload buffer:&noReloadVal size:sizeof(noReloadVal)];
        }
    }

    // 3. Mod Speed Hack
    if (self.speedEnabled) {
        uintptr_t playerAttr = [reader readPointer:localPlayer + kOffsets.PlayerAttributes];
        if (playerAttr != 0) {
            float speed = self.speedMultiplier;
            [reader writeBytes:playerAttr + kOffsets.RunSpeedUpScale buffer:&speed size:sizeof(speed)];
        }
    }

    // 4. Mod Gravity Hack
    if (self.gravityEnabled) {
        uintptr_t playerAttr = [reader readPointer:localPlayer + kOffsets.PlayerAttributes];
        if (playerAttr != 0) {
            float lowGravity = -2.0f;
            [reader writeBytes:playerAttr + kOffsets.RisingGravity buffer:&lowGravity size:sizeof(lowGravity)];
            [reader writeBytes:playerAttr + kOffsets.FallingGravity buffer:&lowGravity size:sizeof(lowGravity)];
        }
    }
}

@end
