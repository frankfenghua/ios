//
//  SNMouse.h
//  ch4-snake
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SNMouse : CCSprite {
    ccTime lifespan;  // How long the mouse will live before disappearing
}

@property (nonatomic, assign) ccTime lifespan;

@end
