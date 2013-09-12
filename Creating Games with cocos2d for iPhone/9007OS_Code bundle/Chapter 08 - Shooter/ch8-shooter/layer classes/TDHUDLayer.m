//
//  TDHUDLayer.m
//  ch8-shooter
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "TDHUDLayer.h"

@implementation TDHUDLayer

-(id) init {
    if(self = [super init]) {
        [self addDisplay];
    }
    return self;
}

-(void) addDisplay {
    // Add the fixed text of the HUD
    CCLabelTTF *kills = [CCLabelTTF labelWithString:@"Kills:" fontName:@"Verdana" fontSize:16];
    [kills setAnchorPoint:ccp(0,0.5)];
    [kills setPosition:ccp(10,305)];
    [kills setColor:ccRED];
    [self addChild:kills];
    
    CCLabelTTF *health = [CCLabelTTF labelWithString:@"Health:" fontName:@"Verdana" fontSize:16];
    [health setAnchorPoint:ccp(0,0.5)];
    [health setPosition:ccp(140,305)];
    [health setColor:ccGREEN];
    [self addChild:health];
    
    CCLabelTTF *goals = [CCLabelTTF labelWithString:@"Goalposts Left:" fontName:@"Verdana" fontSize:16];
    [goals setAnchorPoint:ccp(0,0.5)];
    [goals setPosition:ccp(300,305)];
    [goals setColor:ccBLUE];
    [self addChild:goals];
    
    // Add the kill counter
    lblKills = [CCLabelTTF labelWithString:@"" fontName:@"Verdana" fontSize:16];
    [lblKills setAnchorPoint:ccp(0,0.5)];
    [lblKills setPosition:ccp(60,305)];
    [lblKills setColor:ccRED];
    [self addChild:lblKills];
    
    // Add the health counter
    lblHeroHealth = [CCLabelTTF labelWithString:@"" fontName:@"Verdana" fontSize:16];
    [lblHeroHealth setAnchorPoint:ccp(0,0.5)];
    [lblHeroHealth setPosition:ccp(200,305)];
    [lblHeroHealth setColor:ccGREEN];
    [self addChild:lblHeroHealth];
    
    // Add the goal counter
    lblGoalsRemaining = [CCLabelTTF labelWithString:@"" fontName:@"Verdana" fontSize:16];
    [lblGoalsRemaining setAnchorPoint:ccp(0,0.5)];
    [lblGoalsRemaining setPosition:ccp(430,305)];
    [lblGoalsRemaining setColor:ccBLUE];
    [self addChild:lblGoalsRemaining];
}

-(void) changeHealthTo:(NSInteger)newHealth {
    NSString *newVal = [NSString stringWithFormat:@"%i %%", newHealth];
    
    [lblHeroHealth setString:newVal];
}

-(void) changeGoalTo:(NSInteger)newGoal {
    NSString *newVal = [NSString stringWithFormat:@"%i", newGoal];
    
    [lblGoalsRemaining setString:newVal];
}

-(void) changeKillsTo:(NSInteger)newKills {
    NSString *newVal = [NSString stringWithFormat:@"%i", newKills];
    
    [lblKills setString:newVal];
}

-(void) showGameOver:(NSString*)msg {
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    CCLabelTTF *gameOver = [CCLabelTTF labelWithString:msg fontName:@"Verdana" fontSize:30];
    [gameOver setColor:ccRED];
    [gameOver setPosition:ccp(size.width/2, size.height/2)];
    [self addChild:gameOver z:50];

}


@end
