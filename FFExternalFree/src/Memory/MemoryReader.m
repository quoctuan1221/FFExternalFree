#import "MemoryReader.h"
#import <mach/mach.h>

// Forward declarations for Mach VM APIs on iOS SDK
typedef uint64_t mach_vm_address_t;
typedef uint64_t mach_vm_size_t;

#ifdef __cplusplus
extern "C" {
#endif

extern kern_return_t mach_vm_read_overwrite(
    vm_map_t target_task,
    mach_vm_address_t address,
    mach_vm_size_t size,
    mach_vm_address_t data,
    mach_vm_size_t *outsize
);

extern kern_return_t mach_vm_write(
    vm_map_t target_task,
    mach_vm_address_t address,
    vm_offset_t data,
    mach_msg_type_number_t dataCnt
);

extern kern_return_t task_for_pid(
    mach_port_t target_tport,
    int pid,
    mach_port_t *tn
);

#ifdef __cplusplus
}
#endif

@implementation MemoryReader

+ (instancetype)sharedInstance {
    static MemoryReader *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MemoryReader alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _targetPID = 0;
        _targetTask = 0;
        _baseAddress = 0x100000000; // ASLR Default Base
        _isConnected = NO;
    }
    return self;
}

- (pid_t)getPIDForProcessName:(NSString *)processName {
    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
    size_t size;
    if (sysctl(mib, 4, NULL, &size, NULL, 0) < 0) return 0;

    struct kinfo_proc *procs = malloc(size);
    if (!procs) return 0;

    if (sysctl(mib, 4, procs, &size, NULL, 0) < 0) {
        free(procs);
        return 0;
    }

    int count = (int)(size / sizeof(struct kinfo_proc));
    pid_t resultPID = 0;

    for (int i = 0; i < count; i++) {
        NSString *name = [NSString stringWithUTF8String:procs[i].kp_proc.p_comm];
        if ([name caseInsensitiveCompare:processName] == NSOrderedSame || [name containsString:processName]) {
            resultPID = procs[i].kp_proc.p_pid;
            break;
        }
    }

    free(procs);
    return resultPID;
}

- (BOOL)attachToProcess:(NSString *)processName {
    self.targetPID = [self getPIDForProcessName:processName];
    if (self.targetPID <= 0) {
        self.isConnected = NO;
        return NO;
    }

    kern_return_t kr = task_for_pid(mach_task_self(), self.targetPID, &_targetTask);
    if (kr != KERN_SUCCESS) {
        self.isConnected = NO;
        return NO;
    }

    self.baseAddress = 0x100000000;
    self.isConnected = YES;
    return YES;
}

- (BOOL)readBytes:(uintptr_t)address buffer:(void *)buffer size:(size_t)size {
    if (!self.isConnected || self.targetTask == 0) return NO;
    mach_vm_size_t outSize = 0;
    kern_return_t kr = mach_vm_read_overwrite(self.targetTask, (mach_vm_address_t)address, (mach_vm_size_t)size, (mach_vm_address_t)buffer, &outSize);
    return (kr == KERN_SUCCESS && outSize == size);
}

- (BOOL)writeBytes:(uintptr_t)address buffer:(const void *)buffer size:(size_t)size {
    if (!self.isConnected || self.targetTask == 0) return NO;
    kern_return_t kr = mach_vm_write(self.targetTask, (mach_vm_address_t)address, (vm_offset_t)buffer, (mach_msg_type_number_t)size);
    return (kr == KERN_SUCCESS);
}

- (int32_t)readInt32:(uintptr_t)address {
    int32_t val = 0;
    [self readBytes:address buffer:&val size:sizeof(val)];
    return val;
}

- (uint32_t)readUInt32:(uintptr_t)address {
    uint32_t val = 0;
    [self readBytes:address buffer:&val size:sizeof(val)];
    return val;
}

- (float)readFloat:(uintptr_t)address {
    float val = 0.0f;
    [self readBytes:address buffer:&val size:sizeof(val)];
    return val;
}

- (uintptr_t)readPointer:(uintptr_t)address {
    uintptr_t val = 0;
    [self readBytes:address buffer:&val size:sizeof(val)];
    return val;
}

@end
