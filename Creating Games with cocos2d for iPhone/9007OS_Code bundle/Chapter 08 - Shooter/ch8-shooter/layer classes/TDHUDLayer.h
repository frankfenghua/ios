//
//  TDHUDLayer.h
//  ch8-shooter
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TDHUDLayer : CCLayer {

    CCLabelTTF *lblKills;
    CCLabelTTF *lblGoalsRemaining;
    CCLabelTTF *lblHeroHealth;
}

-(void) changeHealthTo:(NSInteger)newHealth;
-(void) changeGoalTo:(NSInteger)newGoal;
-(void) changeKillsTo:(NSInteger)newKills;

-(void) showGameOver:(NSString*)msg;

@end
