//
//  MXPlayfieldLayer.h
//  ch3-moles
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "MXMenuScene.h"
#import "MXMoleHill.h"
#import "MXMole.h"
#import "MXDefinitions.h"

@interface MXPlayfieldLayer : CCLayer {
    CGSize size; // This is the window size returned from CCDirector
    
    CCSpriteBatchNode *molesheet; // This holds the spritesheet for the game
    
    CCSprite *skybox; // The sky image
    CCSprite *backButton; // simple sprite control to leave the scene
 
    NSMutableArray *moleHillsInPlay; // contains all active Mole Hills
    
    NSInteger molesInPlay; // number of active moles
    
    NSInteger maxMoles; // maximum number of simultaneous moles
    NSInteger maxHillRows; // number of rows of hills
    NSInteger maxHillColumns; // number of columns of hills
    NSInteger maxHills; // number of hills on the board
    
    float moleRaiseTime; // duration it takes as a mole moves up
    float moleDelayTime; // duration a mole pauses at the top
    float moleDownTime; // duration it takes as a mole moves down
    
    float spawnRest; // delay between mole spawnings
    
    NSInteger playerScore; // Current score
    CCLabelTTF *scoreLabel; // Label to display he current score
    
    CCProgressTimer *timerDisplay; // gameplay timer display
    float currentTimerValue; // actual value of time remaining
    float startingTimerValue; // initial value of the timer - we count down
    CCSprite *timerFrame; // The front "face" of the timer
    
    BOOL isGameOver; // indicates if Game Over has been reached

}

@property (nonatomic) float moleRaiseTime;
@property (nonatomic) float moleDelayTime;
@property (nonatomic) float moleDownTime;


@end
