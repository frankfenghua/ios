//
//  ERMenuLayer.m
//  ch9-run
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "ERMenuLayer.h"
#import "ERPlayfieldScene.h"

@implementation ERMenuLayer

-(id) init
{
    if(self = [super init]) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        isStartGame = NO;
        
        // Build a basic title
		CCLabelTTF *title1 = [CCLabelTTF labelWithString:@"Endless Runner" fontName:@"Verdana" fontSize:22];
        [title1 setColor:ccWHITE];
		title1.position =  ccp(size.width/2 , size.height - 120);
		[self addChild: title1];

        // Build the start menu
        CCLabelTTF *startGameLbl = [CCLabelTTF labelWithString:@"Start Game" fontName:@"Verdana" fontSize:22];
        CCMenuItemLabel *startGameItem = [CCMenuItemLabel itemWithLabel:startGameLbl target:self selector:@selector(startGame)];


        CCMenu *startMenu = [CCMenu menuWithItems:startGameItem,
                            nil];
        [startMenu setPosition:ccp(size.width/2, size.height/3)];
        [self addChild:startMenu];
    }
    return self;
}

-(void) startGame {
    
    if (isStartGame == NO) {
        // Start the game, called by the menu item
        isStartGame = YES;
        [[SimpleAudioEngine sharedEngine] playEffect:SND_BUTTON];
        
        [[CCDirector sharedDirector] replaceScene:[ERPlayfieldScene scene]];
    }
}



@end
