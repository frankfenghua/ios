//
//  Spark.m
//  Sample 06
//
//  Created by Lucas Jordan on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Particle.h"


@implementation Particle
@synthesize totalStepsAlive;

+(id)particleAt:(CGPoint)aCenter WithRep:(NSObject<Representation>*)rep Steps:(float)numStepsToLive{ 
    Particle* particle = [[Particle alloc] initAt:aCenter WithRadius:32 AndRepresentation:rep];
    
    [particle setTotalStepsAlive:numStepsToLive];
    
    ExpireAfterTime* expire = [ExpireAfterTime expireAfter:numStepsToLive];
    [expire setDelegate: particle];
    [particle addBehavior:expire];
    
    return particle;
}
-(void)stepsUpdated:(ExpireAfterTime*)expire In:(GameController*)controller{
   self.alpha = [expire stepsRemaining]/totalStepsAlive;
}
@end
