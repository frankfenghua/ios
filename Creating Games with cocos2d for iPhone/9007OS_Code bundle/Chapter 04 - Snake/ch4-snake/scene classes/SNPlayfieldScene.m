//
//  SNPlayfieldScene.m
//  ch4-snake
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "SNPlayfieldScene.h"
#import "SNPlayfieldLayer.h"

@implementation SNPlayfieldScene

+(id) sceneForLevel:(NSInteger)startLevel andDifficulty:(SNSkillLevel)skillLevel {
    return [[[self alloc] initForLevel:startLevel andDifficulty:skillLevel] autorelease];
}

-(id) initForLevel:(NSInteger)startLevel andDifficulty:(SNSkillLevel)skillLevel 
{
	if( (self=[super init])) {
        
        SNPlayfieldLayer *layer = [SNPlayfieldLayer initForLevel:startLevel andDifficulty:skillLevel];
        [self addChild: layer];
	}
	return self;
}

@end
