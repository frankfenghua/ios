//
//  TDMenuScene.m
//  ch8-shooter
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "TDMenuScene.h"
#import "TDMenuLayer.h"

@implementation TDMenuScene

-(id) init
{
	if( (self=[super init])) {
        
        TDMenuLayer *layer = [TDMenuLayer node];
        [self addChild: layer];
	}
	return self;
}

@end

