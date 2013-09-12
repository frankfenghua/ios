//
//  ERMenuLayer.h
//  ch9-run
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "ERDefinitions.h"

@interface ERMenuLayer : CCLayer {

    BOOL isStartGame; // To prevent double-taps
}

@end
