//
//  CLBike.h
//  ch6-cycles
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CLDefinitions.h"

@class CLPlayfieldLayer;

@interface CLBike : CCSprite {
    CGSize size; // Window size returned from CCDirector

    CLPlayfieldLayer *myPlayfield; // game layer
    
    PlayerID _thisPlayerID; // Player Number
    
    ccColor3B _wallColor; // Blue or green color
    
    float _bikeSpeed; // rate of travel for this bike
    Direction _bikeDirection; // facing which direction?
    
    CCSprite *glow; // The colored bulb glow sprite
    
    CCSprite *_currentWall; // Wall connected to bike
    CCSprite *_priorWall; // Wall created before current
    
    NSInteger wallWidth; // How wide the walls are
    
    BOOL isRemotePlayer; // Is this a non-local player?
    BOOL isCrashed; // Did this bike crash?
}

@property (nonatomic, assign) PlayerID thisPlayerID;
@property (nonatomic, assign) float bikeSpeed;
@property (nonatomic, assign) Direction bikeDirection;
@property (nonatomic, assign) ccColor3B wallColor;
@property (nonatomic, assign) BOOL isRemotePlayer;
@property (nonatomic, assign) BOOL isCrashed;
@property (nonatomic, retain) CCSprite *currentWall;
@property (nonatomic, retain) CCSprite *priorWall;

+(id) bikeForPlayer:(PlayerID)playerID 
           PlayerNo:(NSInteger)playerNo 
            onLayer:(CLPlayfieldLayer*)thisLayer
           isRemote:(BOOL)remotePlayer;

-(void) moveForDistance:(float)dist;
-(void) move;
-(void) turnRight;
-(void) turnLeft;
-(void) crash;

-(CGPoint) wallAnchorPoint;

@end
