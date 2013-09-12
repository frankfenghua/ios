//
//  ERHero.h
//  ch9-run
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ERDefinitions.h"
#import "ERBullet.h"

@class ERPlayfieldLayer;

@interface ERHero : CCSprite {
    
    ERPlayfieldLayer *pf; // The playfield
    
    HeroState _state; // Simple state memory
    
    CGRect footSensor;
    CGRect fallSensor;
    
    NSInteger heroHealth;
    BOOL isFlashing;
}

@property (nonatomic, readonly) HeroState state;
@property (nonatomic, assign) ERPlayfieldLayer *pf;
@property (nonatomic, assign) CGRect footSensor;
@property (nonatomic, assign) CGRect fallSensor;

-(void) stateChangeTo:(HeroState)newState;

-(void) shoot;
-(void) gotShot;

-(void) loadAnimations;

@end
