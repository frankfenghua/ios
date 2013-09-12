//
//  SNMenuScene.m
//  ch4-snake
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "SNMenuScene.h"
#import "SNMenuLayer.h"

@implementation SNMenuScene

+(id)scene {
    return( [ [ [ self alloc ] init ] autorelease ] );
}

-(id) init
{
	if( (self=[super init])) {
        
        SNMenuLayer *layer = [SNMenuLayer node];
        [self addChild: layer];
	}
	return self;
}

@end
