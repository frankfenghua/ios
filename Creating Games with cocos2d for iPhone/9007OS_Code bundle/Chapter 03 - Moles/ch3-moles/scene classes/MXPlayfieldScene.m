//
//  MXPlayfieldScene.m
//  ch3-moles
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "MXPlayfieldScene.h"
#import "MXPlayfieldLayer.h"

@implementation MXPlayfieldScene

+(id)scene {
    return( [ [ [ self alloc ] init ] autorelease ] );
}

-(id) init
{
	if( (self=[super init])) {
        
        MXPlayfieldLayer *layer = [MXPlayfieldLayer node];
        [self addChild: layer];
	}
	return self;
}

@end
