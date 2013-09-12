//
//  OPDefinitions.h
//  ch7-pool
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

// Audio definitions
#define SND_BUTTON @"button.caf"

// Box2D definition
#define PTM_RATIO 32

// Define the pocket's tag
#define kPocket 500

typedef enum {
    kBallNone = -1,
    kBallCue = 0,
    kBallOne,
    kBallTwo,
    kBallThree,
    kBallFour,
    kBallFive,
    kBallSix,
    kBallSeven,
    kBallEight,
    kBallNine,
    kBallTen,
    kBallEleven,
    kBallTwelve,
    kBallThirteen,
    kBallFourteen,
    kBallFifteen
} BallID;

typedef enum {
    kRackTriangle = 50,
    kRackDiamond,
    kRackFailed
} RackLayoutType;


typedef enum {
    kStripes = 100,
    kSolids,
    kOrdered,
    kStripesVsSolids,
    kNone
} GameMode;



