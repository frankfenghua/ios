//
//  GameController.h
//  Sample 06
//
//  Created by Lucas Jordan on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define MAX_PARTICLES 5

#import <UIKit/UIKit.h>
#import <QuartzCore/CADisplayLink.h>
#import "Actor.h"

@interface GameController : UIViewController {
    IBOutlet UIView* actorsView;
    
    CADisplayLink* displayLink;
    
    NSMutableSet* actors;
    NSMutableDictionary* actorClassToActorSet;
    
    NSMutableSet* actorsToBeAdded;
    NSMutableSet* actorsToBeRemoved;
    
    BOOL workComplete;
    long particleCount;
}
@property (nonatomic) long stepNumber;
@property (nonatomic) CGSize gameAreaSize;
@property (nonatomic) BOOL isSetup;
@property (nonatomic) BOOL isPaused;
@property (nonatomic) long score;
@property (nonatomic) long scoreChangedOnStep;
@property (nonatomic, retain) NSMutableArray* sortedActorClasses;

-(void)applyGameLogic;

-(BOOL)doSetup;
-(void)displayLinkCalled;
-(void)updateScene;

-(void)removeActor:(Actor*)actor;
-(void)removeActors:(NSArray*)theActors;
-(void)addActor:(Actor*)actor;
-(void)updateViewForActor:(Actor*)actor;
-(void)removeAllActors;

-(void)doAddActors;
-(void)doRemoveActors;
-(NSMutableSet*)actorsOfType:(Class)clazz;

-(void)incrementScore:(long)amount;
-(void)decrementScore:(long)amount;
@end
