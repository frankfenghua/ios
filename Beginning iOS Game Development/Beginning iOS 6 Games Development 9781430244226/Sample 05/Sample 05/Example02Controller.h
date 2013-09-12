//
//  Example02Controller.h
//  Sample 05
//
//  Created by Lucas Jordan on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CADisplayLink.h>
#import "Viper02.h"
#import "Actor02.h"
#import "Asteroid02.h"

@interface Example02Controller : UIViewController {
    IBOutlet UIView *actorView;
    
    CADisplayLink* displayLink;
    
    //Managing Actors
    NSMutableArray* actors;
    NSMutableDictionary* actorViews;
    NSMutableArray* toBeRemoved;
    
    //Game Logic
    Viper02* viper;
    long stepNumber;
    
}
@property (nonatomic) CGSize gameAreaSize;


-(void)updateScene;
-(void)removeActor:(Actor02*)actor;
-(void)addActor:(Actor02*)actor;
-(void)updateActorView:(Actor02*)actor;
-(void)tapGesture:(UIGestureRecognizer *)gestureRecognizer;
-(IBAction)sliderValueChanged:(id)sender;
-(void)doRemove;

@end
