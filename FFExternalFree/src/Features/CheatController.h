#import <Foundation/Foundation.h>
#import "../Offsets.h"
#import "../Bones.h"
#import "../Memory/MemoryReader.h"

@interface CheatController : NSObject

@property (nonatomic, assign) BOOL espEnabled;
@property (nonatomic, assign) BOOL aimbotEnabled;
@property (nonatomic, assign) BOOL noRecoilEnabled;
@property (nonatomic, assign) BOOL noReloadEnabled;
@property (nonatomic, assign) BOOL speedEnabled;
@property (nonatomic, assign) BOOL gravityEnabled;

@property (nonatomic, assign) float speedMultiplier;
@property (nonatomic, assign) float aimFOV;

+ (instancetype)sharedInstance;
- (void)startLoop;
- (void)stopLoop;

@end
