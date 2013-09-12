//
//  EREnemy.h
//  ch9-run
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ERBullet.h"

@class ERPlayfieldLayer;

@interface EREnemy : CCSprite {
    ERPlayfieldLayer *pf; // The playfield
    
    CGRect fallSensor;
    
    BOOL isMovingRight;
    BOOL isFlying;
    
    ccTime shootTimer;
}

@property (nonatomic, assign) ERPlayfieldLayer *pf;
@property (nonatomic, assign) CGRect fallSensor;
@property (nonatomic, assign) BOOL isMovingRight;
@property (nonatomic, assign) BOOL isFlying;
@property (nonatomic, assign) ccTime shootTimer;

-(void) shoot;
-(void) gotShot;

@end
