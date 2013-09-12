//
//  ERBullet.h
//  ch9-run
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ERBullet : CCSprite {
    BOOL isShootingRight;
    BOOL isHeroBullet;
}

@property (nonatomic, assign) BOOL isShootingRight;
@property (nonatomic, assign) BOOL isHeroBullet;

@end
