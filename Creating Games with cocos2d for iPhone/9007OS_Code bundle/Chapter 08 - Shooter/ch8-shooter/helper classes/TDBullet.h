//
//  TDBullet.h
//  ch8-shooter
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TDDefinitions.h"

@class TDPlayfieldLayer;

@interface TDBullet : CCSprite {
    
    TDPlayfieldLayer *parentLayer;
    
    float totalMoveDist;
    float thisMoveDist;
    
    BOOL isDead; // is this bullet now dead?
    BOOL isEnemy; // did the enemy shoot this?
}

@property (nonatomic, assign) BOOL isDead;
@property (nonatomic, assign) BOOL isEnemy;

+(id) bulletFactoryForLayer:(TDPlayfieldLayer*)parentLayer;

-(void) update:(ccTime)dt;

@end
