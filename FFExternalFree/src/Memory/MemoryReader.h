#import <Foundation/Foundation.h>
#import <mach/mach.h>
#import <sys/sysctl.h>

@interface MemoryReader : NSObject

@property (nonatomic, assign) pid_t targetPID;
@property (nonatomic, assign) mach_port_t targetTask;
@property (nonatomic, assign) uintptr_t baseAddress;
@property (nonatomic, assign) BOOL isConnected;

+ (instancetype)sharedInstance;
- (BOOL)attachToProcess:(NSString *)processName;
- (BOOL)readBytes:(uintptr_t)address buffer:(void *)buffer size:(size_t)size;
- (BOOL)writeBytes:(uintptr_t)address buffer:(const void *)buffer size:(size_t)size;

- (int32_t)readInt32:(uintptr_t)address;
- (uint32_t)readUInt32:(uintptr_t)address;
- (float)readFloat:(uintptr_t)address;
- (uintptr_t)readPointer:(uintptr_t)address;

@end
