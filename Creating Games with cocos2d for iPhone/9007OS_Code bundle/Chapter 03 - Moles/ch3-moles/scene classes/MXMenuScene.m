//
//  MXMenuScene.m
//  ch3-moles
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "MXMenuScene.h"
#import "MXMenuLayer.h"

@implementation MXMenuScene

+(id)scene {
    return( [ [ [ self alloc ] init ] autorelease ] );
}

-(id) init
{
	if( (self=[super init])) {
        
        MXMenuLayer *layer = [MXMenuLayer node];
        [self addChild: layer];
	}
	return self;
}

@end
