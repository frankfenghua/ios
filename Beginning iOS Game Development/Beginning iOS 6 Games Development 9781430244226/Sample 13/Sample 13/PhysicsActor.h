//
//  PhysicsActor.h
//  Sample 13
//
//  Created by Lucas Jordan on 8/28/12.
//  Copyright (c) 2012 Lucas Jordan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Box2D/Box2D.h>
#import "Actor.h"
#import "PhysicsViewController.h"

@interface PhysicsActor : Actor

@property (nonatomic) b2Body* body;

-(b2BodyDef)createBodyDef;
@end
