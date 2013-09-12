//
//  PhysicsActor.m
//  Sample 13
//
//  Created by Lucas Jordan on 8/28/12.
//  Copyright (c) 2012 Lucas Jordan. All rights reserved.
//

#import "PhysicsActor.h"


@implementation PhysicsActor
@synthesize body;
-(b2BodyDef)createBodyDef{
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = [PhysicsViewController convertPointToB2:self.center];
    return bodyDef;
}
-(void)step:(GameController *)controller{
    b2Vec2 position = body->GetPosition();
    CGPoint center = [PhysicsViewController convertPointToCG:position];
    [self setCenter: center];
    [self setRotation:body->GetAngle()];
}

@end
