//
//  OPMenuScene.mm
//  ch7-pool
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "OPMenuScene.h"
#import "OPMenuLayer.h"

@implementation OPMenuScene

-(id) init
{
	if( (self=[super init])) {
        
        OPMenuLayer *layer = [OPMenuLayer node];
        [self addChild: layer];
	}
	return self;
}

@end

