//
//  BRDefinitions.h
//  ch5-brick
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

// Box2D ratio
#define PTM_RATIO 32

// Audio definitions
#define SND_BUTTON @"button.caf"
#define SND_PADDLE @"latch2.caf"
#define SND_BRICK @"latch1.caf"
#define SND_LOSEBALL @"crunch.caf"

// Object identification
typedef enum {
    kBall = 1,
    kPaddle,
    kBrick,
    kWall,
    kPowerupExpand,
    kPowerupContract,
    kPowerupMultiball
} kObjectType;

typedef enum {
    kBrickBlank = 0,
    kBrickBlue,
    kBrickCyan,
    kBrickGreen,
    kBrickGrey,
    kBrickOrange,
    kBrickPurple,
    kBrickRed,
    kBrickYellow
} BrickType;
