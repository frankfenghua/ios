//
//  MAMenuScene.m
//  ch2-match3
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "MAMenuScene.h"
#import "MAMenuLayer.h"

@implementation MAMenuScene

+(id)scene {
    return( [ [ [ self alloc ] init ] autorelease ] );
}

-(id) init
{
	if( (self=[super init])) {
        
        MAMenuLayer *layer = [MAMenuLayer node];
        [self addChild: layer];
	}
	return self;
}

@end
