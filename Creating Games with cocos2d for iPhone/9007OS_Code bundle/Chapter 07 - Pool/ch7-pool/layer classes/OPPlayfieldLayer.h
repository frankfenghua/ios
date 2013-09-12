//
//  OPPlayfieldLayer.h
//  ch7-pool
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "OPDefinitions.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "OPContactListener.h"
#import "OPBall.h"
#import "PhysicsSprite.h"
#import "OPControlOneTouch.h"
#import "OPControlTwoTouch.h"
#import "OPRulesBase.h"

@interface OPPlayfieldLayer : CCLayer {
    
    CGSize size; // window size returned from CCDirector
    
    CCSpriteBatchNode *poolsheet; // This holds the spritesheet for the game

    CCSprite *table; // The background table image
    CCSprite *poolcue; // The cue stick
    b2Body *cueBallBody; // The cue ball

    BOOL isHitReady; // Is there a hit ready?
    BOOL isGameOver; // If game over is reached
    BOOL isTouchBlocked; // Prevent touches
    BOOL isBallInHand; // After scratch
    
    BOOL pendingTable; //We need to check the play
    
    BallID firstHit; // First ball hit in
    
    CCTexture2D *spriteTexture_;
	b2World* world;
    
    OPContactListener *contactListener;

    OPControlBase *contr;

    OPRulesBase *rules;
    
    NSMutableArray *ballsSunk; // temp array
    
    NSMutableArray *p1BallsSunk;
    NSMutableArray *p2BallsSunk;

    CCSprite *markPlayer; // Indicates player's turn
    
    CCLabelTTF *player1TargetLbl;  //Stripes or solids
    CCLabelTTF *player2TargetLbl;  // Stripes of solids
    
    CCSprite *nextGoal;
    
    CCLabelTTF *message;
    BOOL isUserDismissMsg;
    BOOL isDisplayingMsg;
    
}

@property (nonatomic, assign) BOOL isTouchBlocked;
@property (nonatomic, assign) BOOL isGameOver;
@property (nonatomic, assign) BOOL isHitReady;
@property (nonatomic, assign) BOOL isBallInHand;

@property (nonatomic, retain) CCSprite *table;
@property (nonatomic, retain) CCSprite *poolcue;
@property (nonatomic, assign) BOOL isUserDismissMsg;

+(id) gameWithControl:(NSString*)controls andRules:(NSString*)gameRules;

-(void) makeTheShot;
-(void) returnToMainMenu;

-(CGPoint) getCueBallPos;

-(void) createBall:(BallID)ballID AtPos:(CGPoint)startPos;

-(void) dismissMessage;

@end
