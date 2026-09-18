#import <Foundation/Foundation.h>
#import "../Offsets.h"
#import "../Bones.h"
#import "../Memory/MemoryReader.h"

@interface CheatController : NSObject

// ESP Settings
@property (nonatomic, assign) BOOL espEnabled;
@property (nonatomic, assign) BOOL lineEspEnabled;
@property (nonatomic, assign) BOOL boxEspEnabled;
@property (nonatomic, assign) BOOL infoEspEnabled;
@property (nonatomic, assign) BOOL boneEspEnabled;

// Aimbot Settings
@property (nonatomic, assign) BOOL aimbotEnabled;
@property (nonatomic, assign) BOOL ignoreKnock;
@property (nonatomic, assign) BOOL ignoreBot;
@property (nonatomic, assign) BOOL aimWukong;
@property (nonatomic, assign) float aimSpeed;
@property (nonatomic, assign) float circleSize;
@property (nonatomic, assign) NSInteger aimModeIndex; // 0: Shoot+Scope, 1: Scope Only, 2: Shoot Only
@property (nonatomic, assign) NSInteger aimTargetIndex; // 0: Head, 1: Neck, 2: Chest
@property (nonatomic, assign) NSInteger aimTypeIndex; // 0: Aim FOV, 1: Distance, 2: Crosshair

// Other Settings
@property (nonatomic, assign) BOOL noRecoilEnabled;
@property (nonatomic, assign) BOOL noReloadEnabled;
@property (nonatomic, assign) BOOL speedEnabled;
@property (nonatomic, assign) BOOL gravityEnabled;
@property (nonatomic, assign) float speedMultiplier;

+ (instancetype)sharedInstance;
- (void)startLoop;
- (void)stopLoop;

@end
