//
//  MAPlayfieldLayer.h
//  ch2-match3
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MAMenuScene.h"
#import "MAGem.h"
#import "SimpleAudioEngine.h"

@interface MAPlayfieldLayer : CCLayer {
    CGSize size; // This is the window size returned from CCDirector

    CCSpriteBatchNode *matchsheet; // This holds the spritesheet for the game
    
    CCSprite *backButton; // simple sprite control to leave the scene
    
    NSMutableArray *gemsInPlay; // array that holds all of the gems on the board
    NSMutableArray *gemMatches; // array that holds all scoring matched gems on the board
    NSMutableArray *gemsTouched; // array that holds the gems currently in "touch" mode
    
    NSInteger boardColumns; // Number of gem columns on the board
    NSInteger boardRows; // Number of gem rows on the board
    float boardOffsetWidth; // Spacing from the left edge to start the board
    float boardOffsetHeight;  // Spacing from the bottom edge to start the board
    float padWidth;  // amount of padding between gems
    float padHeight; // amount of padding between gems
    
    NSInteger totalGemsAvailable; // total number of unique gems
    
    CGSize gemSize; // Dimensions of an individual gem
    
    BOOL checkMatches;  // BOOL we set to let us know we need to check for matches
    BOOL gemsMoving;  // BOOL to identify if there are gems still moving
    
    NSInteger movesRemaining; // Projected number of moves remaining/available
    
    NSInteger playerScore; // Current score
    CCLabelTTF *scoreLabel; // Label to display he current score

    CCProgressTimer *timerDisplay; // gameplay timer display
    float currentTimerValue; // actual value of time remaining
    float startingTimerValue; // initial value of the timer - we count down
    
    BOOL isGameOver; // flag for game over condition
}

@end
