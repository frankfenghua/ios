//
//  TDPlayfieldScene.m
//  ch8-shooter
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "TDPlayfieldScene.h"
#import "TDPlayfieldLayer.h"
#import "TDControlLayer.h"
#import "TDHUDLayer.h"

@implementation TDPlayfieldScene

+(id) sceneWithTiltControls:(BOOL)isTilt {
    return [[[self alloc] initWithTiltControls:isTilt] autorelease];
}

-(id) initWithTiltControls:(BOOL)isTilt {
	if( (self=[super init])) {

        TDHUDLayer *hudLayer = [TDHUDLayer node];
        [self addChild:hudLayer z:5];
        
        TDPlayfieldLayer *pf = [TDPlayfieldLayer layerWithHUDLayer:hudLayer];
        [self addChild: pf];
        
        TDControlLayer *controls = [TDControlLayer controlsWithPlayfieldLayer:pf withTilt:isTilt];
        [self addChild:controls z:10];

	}
	return self;
}

@end
