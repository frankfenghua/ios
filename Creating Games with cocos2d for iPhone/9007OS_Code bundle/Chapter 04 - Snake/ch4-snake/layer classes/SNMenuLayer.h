//
//  SNMenuLayer.h
//  ch4-snake
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SNPlayfieldScene.h"
#import "SimpleAudioEngine.h"
#import "SNDefinitions.h"

@interface SNMenuLayer : CCLayer {
    BOOL isStartGame; // To prevent double-taps
}

@end
