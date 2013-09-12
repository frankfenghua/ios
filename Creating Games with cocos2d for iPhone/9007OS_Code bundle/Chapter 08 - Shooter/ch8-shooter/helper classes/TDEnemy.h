//
//  TDEnemy.h
//  ch8-shooter
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TDDefinitions.h"
#import "TDBullet.h"
#import "SimpleAudioEngine.h"

@class TDPlayfieldLayer;

@interface TDEnemy : CCNode {
    TDPlayfieldLayer *parentLayer;
    
    CCSprite *sprite; // sprite for this enemy
    
    ccTime currShootSpeed; // Timer for shoot delay
    ccTime maxShootSpeed; // Delay between shots
}

@property (nonatomic, retain) CCSprite *sprite;

+(id) enemyAtPos:(CGPoint)pos onLayer:(TDPlayfieldLayer*)layer;

-(void) shoot;
-(void) rotateToTarget:(CGPoint)target;

@end
