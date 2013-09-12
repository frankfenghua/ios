//
//  BRMenuLayer.h
//  ch5-brick
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "BRDefinitions.h"

@interface BRMenuLayer : CCLayer {
    
    BOOL isStartGame; // To prevent double-taps
}

@end
