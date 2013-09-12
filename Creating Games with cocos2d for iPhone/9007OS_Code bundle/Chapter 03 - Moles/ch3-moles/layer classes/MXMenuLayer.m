//
//  MXMenuLayer.m
//  ch3-moles
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "MXMenuLayer.h"

@implementation MXMenuLayer

-(id) init
{
    if( (self=[super init])) {
        
        CGSize wins = [[CCDirector sharedDirector] winSize];
        
        isStartGame = NO;
        
        // Build a basic title
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Mole Thumper" dimensions:CGSizeMake(320, 400) hAlignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeWordWrap fontName:@"AnuDaw" fontSize:44];
        [label setColor:ccWHITE];
		label.position =  ccp( wins.width /2 , wins.height/2 - 40 );
		[self addChild: label];
        
        // Build the start menu
        CCLabelTTF *startGameLbl = [CCLabelTTF labelWithString:@"Start Game" fontName:@"AnuDaw" fontSize:22];
        CCMenuItemLabel *startGameItem = [CCMenuItemLabel itemWithLabel:startGameLbl target:self selector:@selector(startGame)];
        CCMenu *startMenu = [CCMenu menuWithItems:startGameItem, nil];
        [startMenu setPosition:ccp(wins.width/2, wins.height/4)];
        [self addChild:startMenu];
    }
    
    return self;
}

-(void) startGame {

    if (isStartGame == NO) {
        // Start the game, called by the menu item
        [[SimpleAudioEngine sharedEngine] playEffect:SND_BUTTON];
        [[CCDirector sharedDirector] replaceScene:[MXPlayfieldScene scene]];
    }
}

@end
