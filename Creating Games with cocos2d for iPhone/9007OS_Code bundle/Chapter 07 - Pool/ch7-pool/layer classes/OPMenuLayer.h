//
//  OPMenuLayer.h
//  ch7-pool
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "OPDefinitions.h"

@interface OPMenuLayer : CCLayer {
    
    BOOL isOneTouch;
    NSString *gameSelected;
    
    CCLabelTTF *contrTitle;
    CCLabelTTF *oneTouch;
    CCLabelTTF *twoTouch;
    CCLabelTTF *rulesTitle;
    CCLabelTTF *eightBall;
    CCLabelTTF *nineBall;
    
    
    
    BOOL isStartGame; // To prevent double-taps
}

@end
