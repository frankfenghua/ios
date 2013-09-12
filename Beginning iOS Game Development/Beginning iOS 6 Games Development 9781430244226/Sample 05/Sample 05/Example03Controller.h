//
//  Example03Controller.h
//  Sample 05
//
//  Created by Lucas Jordan on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CADisplayLink.h>
#import "Viper03.h"
#import "Actor03.h"
#import "Asteroid03.h"


@interface Example03Controller : UIViewController {
    IBOutlet UIView *actorView;
    
    CADisplayLink* displayLink;
    
    //Managing Actors
    NSMutableArray* actors;
    NSMutableDictionary* actorViews;
    NSMutableArray* toBeRemoved;
    
    //Game Logic
    Viper03* viper;
}
@property (nonatomic) long stepNumber;
@property (nonatomic) CGSize gameAreaSize;

-(void)updateScene;
-(void)removeActor:(Actor03*)actor;
-(void)addActor:(Actor03*)actor;
-(void)updateActorView:(Actor03*)actor;
-(void)tapGesture:(UIGestureRecognizer *)gestureRecognizer;
-(void)doRemove;


@end
