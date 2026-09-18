#ifndef BONES_H
#define BONES_H

#include <stdint.h>

typedef enum : uint32_t {
    Bone_Head = 0x49C,
    Bone_Root = 0x4B0,
    Bone_LeftWrist = 0x4DC,
    Bone_Spine = 0x4A4,
    Bone_Hip = 0x4A0,
    Bone_RightCalf = 0x470,
    Bone_LeftCalf = 0x474,
    Bone_RightFoot = 0x4C4,
    Bone_LeftFoot = 0x4C0,
    Bone_RightWrist = 0x4D8,
    Bone_LeftHand = 0x4C8,
    Bone_LeftShoulder = 0x4D0,
    Bone_RightShoulder = 0x4D4,
    Bone_RightWristJoint = 0x494,
    Bone_LeftWristJoint = 0x498,
    Bone_LeftElbow = 0x4E4,
    Bone_RightElbow = 0x4E0,
} BoneType;

#endif // BONES_H
