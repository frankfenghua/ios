//
//  BRMenuScene.mm
//  ch5-brick
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "BRMenuScene.h"
#import "BRMenuLayer.h"

@implementation BRMenuScene

+(id) scene {
    return( [ [ [ self alloc ] init ] autorelease ] );
}

-(id) init
{
	if( (self=[super init])) {
        
        BRMenuLayer *layer = [BRMenuLayer node];
        [self addChild: layer];
	}
	return self;
}

@end

