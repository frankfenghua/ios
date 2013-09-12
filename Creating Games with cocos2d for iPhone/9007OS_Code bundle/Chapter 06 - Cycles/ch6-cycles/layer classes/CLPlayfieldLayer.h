//
//  CLPlayfieldLayer.h
//  ch6-cycles
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "CLDefinitions.h"
#import "CLButton.h"
#import "CLBike.h"
#import <GameKit/GameKit.h>

@interface CLPlayfieldLayer : CCLayer <GKPeerPickerControllerDelegate, GKSessionDelegate> {
    
    CGSize size; // window size returned from CCDirector
    
    CCSpriteBatchNode *cyclesheet; // This holds the spritesheet for the game

    BOOL isGameOver; // If game over is reached
    BOOL isTouchBlocked; // Prevent touches
    
    CLBike *redBike; // Red player's bike
    CLBike *blueBike; // Blue player's bike

    NSMutableArray *bikeWalls; // All wall sprites
    
    BOOL remoteGame; // Is this a non-local game?
    
    // GameKit specific variables
    GKPeerPickerController *gkPicker; // Peer Picker
    GKSession *gkSession; // The session
    NSString *gamePeerId; // Identifier from peer
    NSInteger playerNumber; // To assign bike colors
    
    GKPeerConnectionState currentState;
}

@property (nonatomic, retain) CCSpriteBatchNode *cyclesheet;
@property (nonatomic, assign) BOOL remoteGame;
@property (nonatomic, assign) BOOL isTouchBlocked;

+(id) gameWithRemoteGame:(BOOL)isRemoteGame;

-(CCSprite*) createWallFromBike:(CLBike*)thisBike;

-(void) sendDataWithDirection:(Direction)dir orDistance:(float)dist;

@end
