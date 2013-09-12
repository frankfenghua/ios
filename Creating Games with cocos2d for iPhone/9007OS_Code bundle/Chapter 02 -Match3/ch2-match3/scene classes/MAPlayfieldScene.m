//
//  MAPlayfieldScene.m
//  ch2-match3
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "MAPlayfieldScene.h"
#import "MAPlayfieldLayer.h"

@implementation MAPlayfieldScene

+(id)scene {
    return( [ [ [ self alloc ] init ] autorelease ] );
}

-(id) init
{
	if( (self=[super init])) {
        
        MAPlayfieldLayer *layer = [MAPlayfieldLayer node];
        [self addChild: layer];
	}
	return self;
}

@end
