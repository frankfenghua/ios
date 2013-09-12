//
//  MXMenuLayer.h
//  ch3-moles
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MXPlayfieldScene.h"
#import "SimpleAudioEngine.h"
#import "MXDefinitions.h"

@interface MXMenuLayer : CCLayer {
    BOOL isStartGame; // To prevent double-taps
}

@end
