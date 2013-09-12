//
//  ERPlayfieldScene.m
//  ch9-run
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "ERPlayfieldScene.h"
#import "ERPlayfieldLayer.h"

@implementation ERPlayfieldScene

+(id) scene {
    return [[[self alloc] init] autorelease];
}

-(id) init
{
	if( (self=[super init])) {
        
        ERPlayfieldLayer *layer = [ERPlayfieldLayer node];
        [self addChild: layer];
	}
	return self;
}

@end
