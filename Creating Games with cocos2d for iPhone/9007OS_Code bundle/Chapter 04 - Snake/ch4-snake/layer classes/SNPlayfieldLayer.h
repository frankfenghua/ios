//
//  SNPlayfieldLayer.h
//  ch4-snake
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "SNMenuScene.h"
#import "SNSnake.h"
#import "SNDefinitions.h"
#import "SNPlayfieldScene.h"
#import "SNMouse.h"

@interface SNPlayfieldLayer : CCLayer {
    CGSize size; // CCDirector window size
    
    CCSpriteBatchNode *snakesheet; // The spritesheet
    
    NSInteger playerScore; // Current score
    
    SNSnake *snake;  // The snake object itself

    
    ccTime stepTime; // Used in update for time elapsed
    
    NSMutableArray *wallsOnField; // Walls in this array
    NSMutableArray *miceOnField; // Mice in this array
    NSMutableArray *deadMice; // Eaten mice here
    
    NSInteger levelNum; // Current level number
    SNSkillLevel currentSkill; // Current difficulty
    
    NSInteger wallCount;  // Number of walls on the level
    NSInteger mouseCount;  // Number of simultaneous mice
    
    CCLabelTTF *leftLabel; // Instructions label
    CCLabelTTF *rightLabel; // Instructions label
    
    CCLabelTTF *levelLabel; // label used for new level

    BOOL isPaused;  // Is the game paused?
    BOOL isGameOver;  // Is the game over?
    BOOL preventTouches; // Prevent tracking touches?
}

+(id) initForLevel:(NSInteger)levelNum
     andDifficulty:(SNSkillLevel)skillLevel;

-(CGPoint) positionForRow:(NSInteger)rowNum
                andColumn:(NSInteger)colNum;

@end
