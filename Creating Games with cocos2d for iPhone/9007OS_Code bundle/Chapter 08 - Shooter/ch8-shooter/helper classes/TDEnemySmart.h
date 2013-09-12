//
//  TDEnemySmart.h
//  ch8-shooter
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TDEnemy.h"
#import "AStarNode.h"

@interface TDEnemySmart : TDEnemy {
    NSMutableArray *spOpenSteps;
    NSMutableArray *spClosedSteps;
    NSMutableArray *shortestPath;
    CCAction *currentStepAction;
    NSValue *pendingMove;
    
    ccTime pathTimer; // How fast we recalc the path
    
    BOOL isUsingPathfinding;
}

@property (nonatomic, retain) NSMutableArray *spOpenSteps;
@property (nonatomic, retain) NSMutableArray *spClosedSteps;
@property (nonatomic, retain) NSMutableArray *shortestPath;
@property (nonatomic, retain) CCAction *currentStepAction;
@property (nonatomic, retain) NSValue *pendingMove;


@end
