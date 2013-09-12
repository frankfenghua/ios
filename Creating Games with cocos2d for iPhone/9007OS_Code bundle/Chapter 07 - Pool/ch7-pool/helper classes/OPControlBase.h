//
//  OPControlBase.h
//  ch7-pool
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class OPPlayfieldLayer;

@interface OPControlBase : CCLayer {
    OPPlayfieldLayer *mp; // Main playfield
    
    float shotLength; // Length of the stroke
    CGPoint plannedHit; // Where the cue will hit
    
    CCLabelTTF *shootButton; // Only used by 2 touch
    
    CGPoint aimAtPoint; // Point the cue will aim at
    
    CCSprite *cueBallInHand; // For placing the cue ball
}

@property (nonatomic, assign) OPPlayfieldLayer *mp;
@property (nonatomic, assign) float shotLength;
@property (nonatomic, assign) CGPoint plannedHit;
@property (nonatomic, assign) CGPoint aimAtPoint;

-(void) updateCueAimFromLoc:(CGPoint)convLoc;
-(void) hideCue;

@end
