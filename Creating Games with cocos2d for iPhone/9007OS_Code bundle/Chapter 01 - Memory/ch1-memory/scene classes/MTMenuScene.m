//
//  MTMenuScene.m
//  ch1-memory
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "MTMenuScene.h"

@implementation MTMenuScene

+(id)scene {
    return( [ [ [ self alloc ] init ] autorelease ] );
}

-(id) init
{
	if( (self=[super init])) {
        MTMenuLayer *layer = [MTMenuLayer node];
        [self addChild: layer];
	}
	return self;
}

@end
