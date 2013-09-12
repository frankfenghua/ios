//
//  MTPlayfieldScene.h
//  ch1-memory
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MTPlayfieldLayer.h"

@interface MTPlayfieldScene : CCScene {
}

+(id) sceneWithRows:(NSInteger)numRows andColumns:(NSInteger)numCols;

@end
