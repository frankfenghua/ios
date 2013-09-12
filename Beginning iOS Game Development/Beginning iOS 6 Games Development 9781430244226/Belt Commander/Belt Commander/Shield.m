//
//  Shield.m
//  Sample 06
//
//  Created by Lucas Jordan on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Shield.h"
#import "FollowActor.h"
#import "ImageRepresentation.h"

@implementation Shield


+(id)shieldProtecting:(Actor*)anActor From:(Actor*)otherActor{
    
    ImageRepresentation* rep = [ImageRepresentation imageRepWithName:@"shield"];
   
    Shield* shield = [[Shield alloc] initAt:[anActor center] WithRadius:[anActor radius] AndRepresentation:rep];
    
    
    [shield addBehavior: [FollowActor followActor:anActor]];
    ExpireAfterTime* expire = [ExpireAfterTime expireAfter:60];
    [shield addBehavior: expire];
    [expire setDelegate:shield];
    
    
    float dx = (otherActor.center.x - anActor.center.x);
    float dy = (otherActor.center.y - anActor.center.y);
    float theta = -atan(dx/dy);
    
    float rotation;

    
    if (dy > 0){
        rotation = theta + M_PI;
    } else {
        rotation = theta;
    }

    [shield setRotation:rotation];
    
    return shield;
}
-(int)getFrameCountForVariant:(int)aVariant AndState:(int)aState{
    return 0;
}
-(void)stepsUpdated:(ExpireAfterTime*)expire In:(GameController*)controller{
    float halfDuration = [expire startingStepCount]/2;
    float remainingSteps = [expire stepsRemaining];
    if (remainingSteps < halfDuration){
        [self setAlpha: remainingSteps/halfDuration];
    }
}
@end
