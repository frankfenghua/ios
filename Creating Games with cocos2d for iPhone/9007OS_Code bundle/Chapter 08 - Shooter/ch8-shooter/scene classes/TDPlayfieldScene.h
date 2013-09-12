//
//  TDPlayfieldScene.h
//  ch8-shooter
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TDDefinitions.h"

@interface TDPlayfieldScene : CCScene {
}

+(id) sceneWithTiltControls:(BOOL)isTilt;

@end
