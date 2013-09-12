//
//  OPRulesBase.h
//  ch7-pool
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "OPDefinitions.h"

@interface OPRulesBase : CCNode {
    // Basic rules
    RackLayoutType rackStyle;
    BallID lastBall;
    BOOL orderedBalls;
    GameMode gameMode;
    BOOL replaceBalls;
    
    BOOL isBreak;
    
    GameMode player1Goal;
    GameMode player2Goal;
    
    BallID nextOrderedBall; // Number of next ball
    
    NSInteger currentPlayer;
    
    BOOL isTableScratch;
    
}

@property (nonatomic, assign) RackLayoutType rackStyle;
@property (nonatomic, assign) BallID lastBall;
@property (nonatomic, assign) BOOL orderedBalls;
@property (nonatomic, assign) GameMode gameMode;
@property (nonatomic, assign) BOOL replaceBalls;

@property (nonatomic, assign) NSInteger currentPlayer;
@property (nonatomic, assign) BOOL isTableScratch;

@property (nonatomic, assign) GameMode player1Goal;
@property (nonatomic, assign) GameMode player2Goal;

@property (nonatomic, assign) BallID nextOrderedBall;

-(id) initWithRulesForGame:(NSString*)gameName;

-(BOOL) isLegalFirstHit:(BallID)firstBall;
-(BOOL) didSinkValidBall:(NSArray*)ballArray;
-(BOOL) didSinkLastBall:(NSArray*)ballArray;
-(BOOL) didSinkCueBall:(NSArray*)ballArray;
-(BOOL) isValidLastBall:(NSArray*)ballsSunk withBallsOnTable:(NSArray*)ballsOnTable;

-(void) findNextOrderedBall:(NSArray*)tableBalls;

@end
