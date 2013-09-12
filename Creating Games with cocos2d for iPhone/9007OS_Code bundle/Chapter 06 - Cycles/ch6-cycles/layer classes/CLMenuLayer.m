//
//  CLMenuLayer.m
//  ch6-cycles
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "CLMenuLayer.h"
#import "CLPlayfieldScene.h"

@implementation CLMenuLayer

-(id) init
{
    if(self = [super init]) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        isStartGame = NO;
        
        // Build a basic title
		CCLabelTTF *title1 = [CCLabelTTF labelWithString:@"Cycles of Light" fontName:@"Verdana" fontSize:44];
        [title1 setColor:ccWHITE];
		title1.position =  ccp(size.width/2 , size.height - 120);
		[self addChild: title1];

        // Build the start menu
        CCLabelTTF *startGameLocalLbl = [CCLabelTTF labelWithString:@"Two Player Game (one device)" fontName:@"Verdana" fontSize:22];
        CCMenuItemLabel *startGameLocalItem = [CCMenuItemLabel itemWithLabel:startGameLocalLbl target:self selector:@selector(startGameLocal)];

        CCLabelTTF *startGameRemoteLbl = [CCLabelTTF labelWithString:@"Two Player Game (two devices)" fontName:@"Verdana" fontSize:22];
        CCMenuItemLabel *startGameRemoteItem = [CCMenuItemLabel itemWithLabel:startGameRemoteLbl target:self selector:@selector(startGameRemote)];

        CCMenu *startMenu = [CCMenu menuWithItems:startGameLocalItem,
                             startGameRemoteItem, nil];
        [startMenu setPosition:ccp(size.width/2, size.height/4)];
        [startMenu alignItemsVerticallyWithPadding:25.0];
        [self addChild:startMenu];
    }
    
    return self;
}

-(void) startGameLocal {
    
    if (isStartGame == NO) {
        // Start the game, called by the menu item
        isStartGame = YES;
        [[SimpleAudioEngine sharedEngine] playEffect:SND_BUTTON];
        [[CCDirector sharedDirector] replaceScene:[CLPlayfieldScene sceneWithRemoteGame:NO]];
    }
}

-(void) startGameRemote {
    
    if (isStartGame == NO) {
        // Start the game, called by the menu item
        isStartGame = YES;
        [[SimpleAudioEngine sharedEngine] playEffect:SND_BUTTON];
        [[CCDirector sharedDirector] replaceScene:[CLPlayfieldScene sceneWithRemoteGame:YES]];
    }
}

@end
