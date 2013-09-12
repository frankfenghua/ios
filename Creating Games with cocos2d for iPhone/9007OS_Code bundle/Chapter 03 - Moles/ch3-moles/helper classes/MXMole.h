//
//  MXMole.h
//  ch3-moles
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MXDefinitions.h"
#import "SimpleAudioEngine.h"

// Forward declaration, since we don't want to import it here
@class MXMoleHill;

@interface MXMole : CCNode <CCTargetedTouchDelegate> {
	CCSprite *moleSprite;  // The sprite for the mole
    MXMoleHill *parentHill;  // The hill for this mole
	float moleGroundY;  // Where "ground" is
    MoleState _moleState; // Current state of the mole
    BOOL isSpecial; // Is this a "special" mole?
}

@property (nonatomic, retain) MXMoleHill *parentHill;
@property (nonatomic, retain) CCSprite *moleSprite;
@property (nonatomic, assign) float moleGroundY;
@property (nonatomic, assign) MoleState moleState;
@property (nonatomic, assign) BOOL isSpecial;

-(void) destroyTouchDelegate;

@end
