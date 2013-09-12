//
//  ERDefinitions.h
//  ch9-run
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//


// Audio definitions
#define SND_BUTTON @"button.caf"
#define SND_ENEMYDEAD @"enemydead.caf"
#define SND_ENEMYSHOOT @"enemyshoot.caf"
#define SND_HERODEATH @"herodeath.caf"
#define SND_HEROHIT @"herohit.caf"
#define SND_HEROSHOOT @"heroshoot.caf"
#define SND_HEROJUMP @"jump.caf"
#define SND_SHIP @"ship.caf"

// Graphic Definitions
#define IMG_BULLET @"bullet.png"

typedef enum {
    kHeroRunning = 1,
    kHeroJumping,
    kHeroInAir,
    kHeroFalling
} HeroState;
