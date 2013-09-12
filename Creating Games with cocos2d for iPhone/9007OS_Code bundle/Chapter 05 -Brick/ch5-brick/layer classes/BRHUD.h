//
//  BRHUD.h
//  ch5-brick
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class BRGameHandler;

@interface BRHUD : CCLayer {

    CGSize wins; // This is the window size returned from CCDirector
    
    CCSpriteBatchNode *bricksheet; // This holds the spritesheet for the game
    
    BRGameHandler *gh; // Singleton that holds the player progress data

    CCSprite *legendBox; // Box where the score and lives are displayed
    
    CCLabelTTF *scoreTitle; // The word "SCORE"
    CCLabelTTF *scoreDisplay; // The actual player score
    CCLabelTTF *livesTitle; // The word "LIVES"
    
    NSMutableArray *livesArray; // Array to hold images for life display
}

-(void) addToScore:(NSInteger)newPoints;

-(void) loseLife;

@end
