//
//  TDHero.h
//  ch8-shooter
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

@class TDPlayfieldLayer;

@interface TDHero : CCNode {
    TDPlayfieldLayer *parentLayer;
    CCSprite *sprite; // sprite for the hero
}

@property (nonatomic, retain) CCSprite *sprite;

+(id) heroAtPos:(CGPoint)pos onLayer:(TDPlayfieldLayer*)layer;

-(void) shoot;
-(void) rotateToTarget:(CGPoint)target;

@end
