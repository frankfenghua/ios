//
//  TDControlLayer.h
//  ch8-shooter
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedBase.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"
#import "ColoredCircleSprite.h"

@class TDPlayfieldLayer;

@interface TDControlLayer : CCLayer {
    
    TDPlayfieldLayer *pf;
    
    SneakyJoystick *leftJoystick;
	SneakyButton *rightButton;
    
    BOOL isTiltControl;
    
    float accelX;
    float accelY;
}

+(id) controlsWithPlayfieldLayer:(TDPlayfieldLayer*)playfieldLayer withTilt:(BOOL)isTilt;

@end
