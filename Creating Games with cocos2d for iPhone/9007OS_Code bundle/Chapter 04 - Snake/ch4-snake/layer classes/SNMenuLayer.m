//
//  SNMenuLayer.m
//  ch4-snake
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "SNMenuLayer.h"

@implementation SNMenuLayer

-(id) init
{
    if( (self=[super init])) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        isStartGame = NO;
        
        // Build a basic title
		CCLabelTTF *label = [CCLabelTTF
                        labelWithString:@"Snake!!!"
                        fontName:@"Verdana" fontSize:44];
        [label setColor:ccWHITE];
		label.position =  ccp(size.width/2 ,
                              size.height/2 + 40);
		[self addChild: label];
        
        // Build the start menu
        CCLabelTTF *startGameEasyLbl = [CCLabelTTF
            labelWithString:@"Start Game - Easy"
            fontName:@"Verdana" fontSize:22];
        CCMenuItemLabel *startGameEasyItem = [CCMenuItemLabel
            itemWithLabel:startGameEasyLbl target:self
            selector:@selector(startGameEasy)];

        CCLabelTTF *startGameMediumLbl = [CCLabelTTF
            labelWithString:@"Start Game - Medium"
            fontName:@"Verdana" fontSize:22];
        CCMenuItemLabel *startGameMediumItem =
            [CCMenuItemLabel itemWithLabel:startGameMediumLbl
            target:self selector:@selector(startGameMedium)];
        
        CCLabelTTF *startGameHardLbl = [CCLabelTTF
            labelWithString:@"Start Game - Hard"
            fontName:@"Verdana" fontSize:22];
        CCMenuItemLabel *startGameHardItem =
            [CCMenuItemLabel itemWithLabel:startGameHardLbl
            target:self selector:@selector(startGameHard)];
        
        
        CCMenu *startMenu = [CCMenu menuWithItems:
            startGameEasyItem, startGameMediumItem,
            startGameHardItem, nil];
        [startMenu setPosition:ccp(size.width/2,
                                   size.height/4)];
        [startMenu alignItemsVerticallyWithPadding:5];
        [self addChild:startMenu];
    }
    
    return self;
}

-(void) startGameEasy {

    if (isStartGame == NO) {
        // Start the game, called by the menu item
        isStartGame = YES;
        [[SimpleAudioEngine sharedEngine]
                            playEffect:SND_BUTTON];
        [[CCDirector sharedDirector] replaceScene:
                [SNPlayfieldScene sceneForLevel:1
                andDifficulty:kSkillEasy]];
    }
}

-(void) startGameMedium {
    
    if (isStartGame == NO) {
        // Start the game, called by the menu item
        isStartGame = YES;
        [[SimpleAudioEngine sharedEngine]
                                playEffect:SND_BUTTON];
        [[CCDirector sharedDirector] replaceScene:
                [SNPlayfieldScene sceneForLevel:1
                andDifficulty:kSkillMedium]];
    }
}

-(void) startGameHard {
    
    if (isStartGame == NO) {
        // Start the game, called by the menu item
        isStartGame = YES;
        [[SimpleAudioEngine sharedEngine]
                                playEffect:SND_BUTTON];
        [[CCDirector sharedDirector] replaceScene:
                    [SNPlayfieldScene sceneForLevel:1
                    andDifficulty:kSkillHard]];
    }
}

@end
