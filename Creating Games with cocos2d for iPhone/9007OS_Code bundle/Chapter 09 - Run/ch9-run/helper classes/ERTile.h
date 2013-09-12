//
//  ERTile.h
//  ch9-run
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ERTile : CCSprite {
    CGRect topSensor;
    
    BOOL isTop; // Is the top of a stack
}

@property (nonatomic, assign) CGRect topSensor;
@property (nonatomic, assign) BOOL isTop;

@end
