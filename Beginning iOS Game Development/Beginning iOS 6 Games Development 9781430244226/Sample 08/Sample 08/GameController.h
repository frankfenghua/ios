//
//  GameController.h
//  Sample 06
//
//  Created by Lucas Jordan on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

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
}
@property (nonatomic) long stepNumber;
@property (nonatomic) CGSize gameAreaSize;
@property (nonatomic) BOOL isSetup;
@property (nonatomic, strong) NSMutableArray* sortedActorClasses;

-(BOOL)doSetup;
-(void)displayLinkCalled;
-(void)updateScene;

-(void)removeActor:(Actor*)actor;
-(void)addActor:(Actor*)actor;
-(void)updateViewForActor:(Actor*)actor;

-(void)doAddActors;
-(void)doRemoveActors;
-(NSMutableSet*)actorsOfType:(Class)class;

@end
