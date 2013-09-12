//
//  SNDefinitions.h
//  ch4-snake
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#define gridSize 22

#define SND_BUTTON @"button.caf"
#define SND_GULP @"gulp.caf"
#define SND_CRASH @"crash.caf"

typedef enum {
    kUp = 1,
    kRight,
    kLeft,
    kDown
} SnakeHeading;

typedef enum {
    kTurnLeft = 100,
    kTurnRight,
    kNewWall,
    kNewMouse,
    kSpeed
} SNEventType;

typedef enum {
    kSkillEasy = 1,
    kSkillMedium,
    kSkillHard
} SNSkillLevel;

