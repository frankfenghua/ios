//
//  MTMenuLayer.m
//  ch1-memory
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "MTMenuLayer.h"

@implementation MTMenuLayer

-(id) init
{
    if( (self=[super init])) {

        CGSize wins = [[CCDirector sharedDirector] winSize];

        // Create the title as a label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Memory Game" fontName:@"Marker Felt" fontSize:64];
        [label setColor:ccBLUE];
		label.position =  ccp( wins.width /2 , wins.height/2 + 50 );
		[self addChild: label];
        
        // Create Label Menu Items for the 3 game levels
        CCLabelTTF *startGameEasyLbl = [CCLabelTTF labelWithString:@"Start Game - Easy" fontName:@"Marker Felt" fontSize:22];
        CCMenuItemLabel *startGameEasyItem = [CCMenuItemLabel itemWithLabel:startGameEasyLbl target:self selector:@selector(startGameEasy)];

        CCLabelTTF *startGameMediumLbl = [CCLabelTTF labelWithString:@"Start Game - Medium" fontName:@"Marker Felt" fontSize:22];
        CCMenuItemLabel *startGameMediumItem = [CCMenuItemLabel itemWithLabel:startGameMediumLbl target:self selector:@selector(startGameMedium)];

        CCLabelTTF *startGameHardLbl = [CCLabelTTF labelWithString:@"Start Game - Hard" fontName:@"Marker Felt" fontSize:22];
        CCMenuItemLabel *startGameHardItem = [CCMenuItemLabel itemWithLabel:startGameHardLbl target:self selector:@selector(startGameHard)];

        // Create the menu
        CCMenu *startMenu = [CCMenu menuWithItems:startGameEasyItem, startGameMediumItem, startGameHardItem, nil];
        [startMenu alignItemsVerticallyWithPadding:15];
        [startMenu setPosition:ccp(wins.width/2, wins.height/4)];
        [self addChild:startMenu];
	}
    
    return self;
}

-(void) startGameEasy {
    [[CCDirector sharedDirector] replaceScene:
     [MTPlayfieldScene sceneWithRows:2 andColumns:2]];
}

-(void) startGameMedium {
    [[CCDirector sharedDirector] replaceScene:
     [MTPlayfieldScene sceneWithRows:3 andColumns:4]];
}

-(void) startGameHard {
    [[CCDirector sharedDirector] replaceScene:
     [MTPlayfieldScene sceneWithRows:4 andColumns:5]];
}

@end
