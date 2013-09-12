//
//  OPPlayfieldScene.mm
//  ch7-pool
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "OPPlayfieldScene.h"
#import "OPPlayfieldLayer.h"

@implementation OPPlayfieldScene

+(id) gameWithControl:(NSString*)controls andRules:(NSString*)gameRules {
    return [[[self alloc] initWithControl:controls andRules:gameRules] autorelease];
}

-(id) initWithControl:(NSString*)controls andRules:(NSString*)gameRules {
	if( (self=[super init])) {
        
        OPPlayfieldLayer *layer = [OPPlayfieldLayer gameWithControl:controls andRules:gameRules];
        [self addChild: layer];
	}
	return self;
}

@end
