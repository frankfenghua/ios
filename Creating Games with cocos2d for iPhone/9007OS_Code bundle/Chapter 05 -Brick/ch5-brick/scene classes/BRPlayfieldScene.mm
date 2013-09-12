//
//  BRPlayfieldScene.mm
//  ch5-brick
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "BRPlayfieldScene.h"
#import "BRPlayfieldLayer.h"

@implementation BRPlayfieldScene

+(id) scene
{
	CCScene *scene = [CCScene node];
	BRPlayfieldLayer *layer = [BRPlayfieldLayer node];
	[scene addChild: layer];
	return scene;
}

@end
