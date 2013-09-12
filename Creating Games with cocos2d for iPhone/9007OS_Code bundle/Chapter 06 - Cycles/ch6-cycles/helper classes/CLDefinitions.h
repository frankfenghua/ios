//
//  CLDefinitions.h
//  ch6-cycles
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//


// Audio definitions
#define SND_BUTTON @"button.caf"
#define SND_TURN @"bike_turn.caf"

// Graphics definitions
#define IMG_BIKE @"lightbulb.png"
#define IMG_GLOW @"glow.png"
#define IMG_BUTTON @"rightarrow.png"
#define IMG_SPECK @"whitespeck.png"

typedef enum {
    kBluePlayer,
    kRedPlayer
} PlayerID;

typedef enum {
    kNoChange, // NoChange only used in bluetooth games
    kUp,
    kRight,
    kLeft,
    kDown
} Direction;




