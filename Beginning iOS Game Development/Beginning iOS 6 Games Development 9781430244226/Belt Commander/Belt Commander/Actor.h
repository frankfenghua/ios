//
//  Actor.h
//  Sample 06
//
//  Created by Lucas Jordan on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameController, Actor;

@protocol Representation
-(UIView*)getViewForActor:(Actor*)anActor In:(GameController*)aController;
-(void)updateView:(UIView*)aView ForActor:(Actor*)anActor In:(GameController*)aController;
@end

@protocol Behavior
-(void)applyToActor:(Actor*)anActor In:(GameController*)gameController;
@end

long nextId;
@interface Actor : NSObject {
    
}
//State
@property (nonatomic, retain) NSNumber* actorId;
@property (nonatomic) BOOL added;
@property (nonatomic) BOOL removed;

//Geometry
@property (nonatomic) CGPoint center;
@property (nonatomic) float rotation;
@property (nonatomic) float radius;

//Behavoir
@property (nonatomic, retain) NSMutableArray* behaviors;

//Representation
@property (nonatomic) BOOL needsViewUpdated;
@property (nonatomic, retain) NSObject<Representation>* representation;
@property (nonatomic) int variant;
@property (nonatomic) int state;
@property (nonatomic) float alpha;
@property (nonatomic) BOOL animationPaused;

-(id)initAt:(CGPoint)aPoint WithRadius:(float)aRadius AndRepresentation:(NSObject<Representation>*)aRepresentation;
-(void)step:(GameController*)controller;
-(BOOL)overlapsWith: (Actor*) actor;
-(void)addBehavior:(NSObject<Behavior>*)behavior;

+(CGPoint)randomPointAround:(CGPoint)aCenter At:(float)aRadius;

@end
