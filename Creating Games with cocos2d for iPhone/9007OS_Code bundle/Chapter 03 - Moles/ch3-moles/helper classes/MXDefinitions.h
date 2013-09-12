//
//  MXDefinitions.h
//  ch3-moles
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

// Contains all the "universal" definitions we use for this game

typedef enum {
    kMoleDead = 0,
    kMoleHidden,
    kMoleMoving,
    kMoleHit,
    kMoleAlive
} MoleState;


#define SND_MOLE_NORMAL @"penguin_call.caf"
#define SND_MOLE_SPECIAL @"penguin_call_echo.caf"
#define SND_BUTTON @"button.caf"