//
//  TDMenuLayer.m
//  ch8-shooter
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "TDMenuLayer.h"
#import "TDPlayfieldScene.h"

@implementation TDMenuLayer

-(id) init
{
    if(self = [super init]) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        isStartGame = NO;
        
        // Build a basic title
		CCLabelTTF *title1 = [CCLabelTTF labelWithString:@"Top-Down Shooter" fontName:@"Verdana" fontSize:22];
        [title1 setColor:ccWHITE];
		title1.position =  ccp(size.width/2 , size.height - 120);
		[self addChild: title1];

        // Build the start menu
        CCLabelTTF *startGameTiltLbl = [CCLabelTTF labelWithString:@"Start Game With Tilt Control" fontName:@"Verdana" fontSize:22];
        CCMenuItemLabel *startGameTiltItem = [CCMenuItemLabel itemWithLabel:startGameTiltLbl target:self selector:@selector(startGameWithTilt)];

        CCLabelTTF *startGameLbl = [CCLabelTTF labelWithString:@"Start Game With Joystick Control" fontName:@"Verdana" fontSize:22];
        CCMenuItemLabel *startGameItem = [CCMenuItemLabel itemWithLabel:startGameLbl target:self selector:@selector(startGameWithoutTilt)];

        CCMenu *startMenu = [CCMenu menuWithItems:startGameTiltItem,
                             startGameItem, nil];
        [startMenu setPosition:ccp(size.width/2, size.height/3)];
        [startMenu alignItemsVerticallyWithPadding:10];
        [self addChild:startMenu];
    }
    return self;
}

-(void) startGameWithTilt {
    
    if (isStartGame == NO) {
        // Start the game, called by the menu item
        isStartGame = YES;
        [[SimpleAudioEngine sharedEngine] playEffect:SND_BUTTON];
        
        [[CCDirector sharedDirector] replaceScene:[TDPlayfieldScene sceneWithTiltControls:YES]];
    }
}

-(void) startGameWithoutTilt {
    
    if (isStartGame == NO) {
        // Start the game, called by the menu item
        isStartGame = YES;
        [[SimpleAudioEngine sharedEngine] playEffect:SND_BUTTON];
        
        [[CCDirector sharedDirector] replaceScene:[TDPlayfieldScene sceneWithTiltControls:NO]];
    }
}


@end
