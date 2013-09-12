//
//  OPMenuLayer.mm
//  ch7-pool
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "OPMenuLayer.h"
#import "OPPlayfieldScene.h"

@implementation OPMenuLayer

-(id) init
{
    if(self = [super init]) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        isStartGame = NO;
        
        // Build a basic title
		CCLabelTTF *title1 = [CCLabelTTF labelWithString:@"Pool, Old School" fontName:@"Verdana" fontSize:22];
        [title1 setColor:ccWHITE];
		title1.position =  ccp(size.width/2 , size.height - 120);
		[self addChild: title1];

        contrTitle = [CCLabelTTF labelWithString:@"Controls" fontName:@"Verdana" fontSize:15];
        oneTouch = [CCLabelTTF labelWithString:  @"One Touch" fontName:@"Verdana" fontSize:15];
        twoTouch = [CCLabelTTF labelWithString:  @"Two Touch" fontName:@"Verdana" fontSize:15];
        rulesTitle = [CCLabelTTF labelWithString:@"Rules" fontName:@"Verdana" fontSize:15];
        eightBall = [CCLabelTTF labelWithString: @"Eight Ball" fontName:@"Verdana" fontSize:15];
        nineBall = [CCLabelTTF labelWithString:  @" Nine Ball" fontName:@"Verdana" fontSize:15];
        
        CCMenuItemLabel *contrItem = [CCMenuItemLabel itemWithLabel:contrTitle target:self selector:nil];
        CCMenuItemLabel *oneTouchItem = [CCMenuItemLabel itemWithLabel:oneTouch target:self selector:@selector(setOneTouch)];
        CCMenuItemLabel *twoTouchItem = [CCMenuItemLabel itemWithLabel:twoTouch target:self selector:@selector(setTwoTouch)];

        CCMenuItemLabel *rulesItem = [CCMenuItemLabel itemWithLabel:rulesTitle target:self selector:nil];
        CCMenuItemLabel *eightBallItem = [CCMenuItemLabel itemWithLabel:eightBall target:self selector:@selector(setEightBall)];
        CCMenuItemLabel *nineBallItem = [CCMenuItemLabel itemWithLabel:nineBall target:self selector:@selector(setNineBall)];

        // Build the Controls menu
        CCMenu *contrMenu = [CCMenu menuWithItems:
                             contrItem, oneTouchItem,
                             twoTouchItem, nil];
        [contrMenu alignItemsVerticallyWithPadding:10];
        [contrMenu setPosition:ccp(size.width/4,
                                   size.height/3)];
        [self addChild:contrMenu];

        // Build the Rules menu
        CCMenu *rulesMenu = [CCMenu menuWithItems:
                             rulesItem, eightBallItem,
                             nineBallItem, nil];
        [rulesMenu alignItemsVerticallyWithPadding:10];
        [rulesMenu setPosition:ccp(3 * (size.width/4),
                                   size.height/3)];
        [self addChild:rulesMenu];

        // Build the start menu
        CCLabelTTF *startGameLbl = [CCLabelTTF labelWithString:@"Start Game" fontName:@"Verdana" fontSize:22];
        CCMenuItemLabel *startGameItem = [CCMenuItemLabel itemWithLabel:startGameLbl target:self selector:@selector(startGame)];


        CCMenu *startMenu = [CCMenu menuWithItems:startGameItem,
                            nil];
        [startMenu setPosition:ccp(size.width/2, size.height/8)];
        [self addChild:startMenu];
        
        // Color the headings
        [contrTitle setColor:ccBLUE];
        [rulesTitle setColor:ccRED];
        [startGameLbl setColor:ccGREEN];

        
        // Set the defaults
        [self setOneTouch];
        [self setEightBall];
    }
    return self;
}

-(void) startGame {
    
    if (isStartGame == NO) {
        // Start the game, called by the menu item
        isStartGame = YES;
        [[SimpleAudioEngine sharedEngine] playEffect:SND_BUTTON];
        
        NSString *controls = @"One Touch";
        
        if (isOneTouch == NO) {
            controls = @"Two Touch";
        }
        
        [[CCDirector sharedDirector] replaceScene:[OPPlayfieldScene gameWithControl:controls andRules:gameSelected]];
    }
}

-(void) setOneTouch {
    isOneTouch = YES;
    [oneTouch setFontSize:18];
    [twoTouch setFontSize:15];
}

-(void) setTwoTouch {
    isOneTouch = NO;
    [oneTouch setFontSize:15];
    [twoTouch setFontSize:18];
}

-(void) setEightBall {
    gameSelected = @"Eight Ball";
    [eightBall setFontSize:18];
    [nineBall setFontSize:15];
}

-(void) setNineBall {
    gameSelected = @"Nine Ball";
    [eightBall setFontSize:15];
    [nineBall setFontSize:18];
}


@end
