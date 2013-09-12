//
//  CLPlayfieldScene.m
//  ch6-cycles
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "CLPlayfieldScene.h"
#import "CLPlayfieldLayer.h"

@implementation CLPlayfieldScene

+(id) sceneWithRemoteGame:(BOOL)isRemoteGame {
    return [[[self alloc] initWithRemoteGame:isRemoteGame] autorelease];
}

-(id) initWithRemoteGame:(BOOL)isRemoteGame {
	if( (self=[super init])) {
        
        CLPlayfieldLayer *layer = [CLPlayfieldLayer gameWithRemoteGame:isRemoteGame];
        [self addChild: layer];
	}
	return self;
}


@end
