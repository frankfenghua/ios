//
//  SNPlayfieldScene.h
//  ch4-snake
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SNDefinitions.h"

@interface SNPlayfieldScene : CCScene {
}

+(id) sceneForLevel:(NSInteger)startLevel andDifficulty:(SNSkillLevel)skillLevel;

@end
