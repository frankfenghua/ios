//
//  BRMenuLayer.mm
//  ch5-brick
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "BRMenuLayer.h"
#import "BRPlayfieldScene.h"

@implementation BRMenuLayer

-(id) init
{
    if( (self=[super init])) {
        
        CGSize wins = [[CCDirector sharedDirector] winSize];
        
        isStartGame = NO;
        
        // Build a basic title
		CCLabelTTF *title1 = [CCLabelTTF labelWithString:@"Brick" fontName:@"Alpha Echo" fontSize:44];
        [title1 setColor:ccWHITE];
		title1.position =  ccp(wins.width/2 , wins.height - 120);
		[self addChild: title1];

        CCLabelTTF *title2 = [CCLabelTTF labelWithString:@"Breaker" fontName:@"Alpha Echo" fontSize:44];
        [title2 setColor:ccWHITE];
		title2.position =  ccp(wins.width/2 , wins.height - 160);
		[self addChild: title2];

        // Build the start menu
        CCLabelTTF *startGameLbl = [CCLabelTTF labelWithString:@"Start Game" fontName:@"Alpha Echo" fontSize:22];
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
        isStartGame = YES;
        [[SimpleAudioEngine sharedEngine] playEffect:SND_BUTTON];
        [[CCDirector sharedDirector] replaceScene:[BRPlayfieldScene scene]];
    }
}


@end
