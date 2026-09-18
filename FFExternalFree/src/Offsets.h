#ifndef OFFSETS_H
#define OFFSETS_H

#include <stdint.h>

// Game Offsets (Converted from Offsets.cs.txt)
typedef struct {
    uintptr_t InitBase;
    uintptr_t CurrentMatch;
    uintptr_t MatchStatus;
    uintptr_t LocalPlayer;
    uintptr_t DictionaryEntities;
    uintptr_t Player_IsDead;
    uintptr_t Player_Name;
    uintptr_t Player_Data;
    uintptr_t Player_ShadowBase;
    uintptr_t XPose;
    uintptr_t AvatarManager;
    uintptr_t Avatar;
    uintptr_t Avatar_IsVisible;
    uintptr_t Avatar_Data;
    uintptr_t Avatar_Data_IsTeam;
    uintptr_t PlayerID;
    uintptr_t FollowCamera;
    uintptr_t Camera;
    uintptr_t MainCameraTransform;
    uintptr_t AimRotation;
    uintptr_t CurrentObserver;
    uintptr_t ObserverPlayer;
    uintptr_t PlayerAttributes;
    uintptr_t NoReload;
    uintptr_t RunSpeedUpScale;
    uintptr_t GameTimer;
    uintptr_t FixedDeltaTime;
    uintptr_t Weapon;
    uintptr_t WeaponData;
    uintptr_t WeaponRecoil;
    uintptr_t UnkPlayerWeaponInfoClass;
    uintptr_t IsCombineWeapon;
    uintptr_t WeaponOnHand;
    uintptr_t CombineWeaponOnHand;
    uintptr_t WeaponInfo;
    uintptr_t WeaponID;
    uintptr_t LastAimingInfoFromWeapon;
    uintptr_t IS_FIRING;
    uintptr_t StartPosition;
    uintptr_t RayDir;
    uintptr_t LockedAimingCollider;
    uintptr_t Collider;
    uintptr_t BaseProfileInfo;
    uintptr_t IsClientBot;
    uintptr_t StaticClass;
    uintptr_t FollowCamera_m_RightOffset;
    uintptr_t FollowCamera_m_UpOffset;
    uintptr_t FollowCamera_m_VisionSpeed;
    uintptr_t ViewMatrix;
    uintptr_t LocalPlayerAttributes;

    // Silent Aim / Aimbot
    uintptr_t sAim1;
    uintptr_t sAim2;
    uintptr_t sAim3;
    uintptr_t sAim4;

    uintptr_t GameFacade;
    uintptr_t RisingGravity;
    uintptr_t FallingGravity;
    uintptr_t pomba;
    uintptr_t AimWrite;
} GameOffsets;

static const GameOffsets kOffsets = {
    .InitBase = 0xA342EFC,
    .CurrentMatch = 0x50,
    .MatchStatus = 0x8C,
    .LocalPlayer = 0x94,
    .DictionaryEntities = 0x68,
    .Player_IsDead = 0x50,
    .Player_Name = 0x31C,
    .Player_Data = 0x48,
    .Player_ShadowBase = 0x1A60,
    .XPose = 0x78,
    .AvatarManager = 0x504,
    .Avatar = 0xA8,
    .Avatar_IsVisible = 0x95,
    .Avatar_Data = 0x14,
    .Avatar_Data_IsTeam = 0x59,
    .PlayerID = 0x268,
    .FollowCamera = 0x494,
    .Camera = 0x18,
    .MainCameraTransform = 0x28C,
    .AimRotation = 0x440,
    .CurrentObserver = 0xB4,
    .ObserverPlayer = 0x28,
    .PlayerAttributes = 0x500,
    .NoReload = 0xC1,
    .RunSpeedUpScale = 0x1D8,
    .GameTimer = 0x10,
    .FixedDeltaTime = 0x24,
    .Weapon = 0x434,
    .WeaponData = 0x58,
    .WeaponRecoil = 0xC,
    .UnkPlayerWeaponInfoClass = 0x4A8,
    .IsCombineWeapon = 0xD8,
    .WeaponOnHand = 0x54,
    .CombineWeaponOnHand = 0x58,
    .WeaponInfo = 0x9D0,
    .WeaponID = 0x14,
    .LastAimingInfoFromWeapon = 0x9D0,
    .IS_FIRING = 0x58C,
    .StartPosition = 0x38,
    .RayDir = 0x2C,
    .LockedAimingCollider = 0x54,
    .Collider = 0x4E8,
    .BaseProfileInfo = 0x18CC,
    .IsClientBot = 0x324,
    .StaticClass = 0x5C,
    .FollowCamera_m_RightOffset = 0x64,
    .FollowCamera_m_UpOffset = 0x68,
    .FollowCamera_m_VisionSpeed = 0x48,
    .ViewMatrix = 0xE8,
    .LocalPlayerAttributes = 0x500,

    .sAim1 = 0x58C,
    .sAim2 = 0x9D0,
    .sAim3 = 0x38,
    .sAim4 = 0x2C,

    .GameFacade = 0xABFF3C0,
    .RisingGravity = 0x15F0,
    .FallingGravity = 0x15F4,
    .pomba = 0x544,
    .AimWrite = 0x54
};

#endif // OFFSETS_H
