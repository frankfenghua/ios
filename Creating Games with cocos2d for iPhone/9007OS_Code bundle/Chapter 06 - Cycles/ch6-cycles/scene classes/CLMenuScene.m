//
//  CLMenuScene.m
//  ch6-cycles
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "CLMenuScene.h"
#import "CLMenuLayer.h"

@implementation CLMenuScene

-(id) init
{
	if( (self=[super init])) {
        
        CLMenuLayer *layer = [CLMenuLayer node];
        [self addChild: layer];
	}
	return self;
}

@end

