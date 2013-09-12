//
//  ERMenuScene.m
//  ch9-run
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "ERMenuScene.h"
#import "ERMenuLayer.h"

@implementation ERMenuScene

+(id) scene {
    return [[[self alloc] init] autorelease];
}

-(id) init
{
	if( (self=[super init])) {
        
        ERMenuLayer *layer = [ERMenuLayer node];
        [self addChild: layer];
	}
	return self;
}

@end

