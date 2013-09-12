//
//  ExpireAfterTime.m
//  Sample 06
//
//  Created by Lucas Jordan on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExpireAfterTime.h"
#import "GameController.h"

@implementation ExpireAfterTime
@synthesize stepsRemaining;
@synthesize delegate;
@synthesize startingStepCount;

+(id)expireAfter:(long)aNumberOfSteps {
    ExpireAfterTime* expires = [ExpireAfterTime new];
    [expires setStepsRemaining: aNumberOfSteps];
    [expires setStartingStepCount:aNumberOfSteps];
    return expires;
}

-(void)applyToActor:(Actor*)anActor In:(GameController*)gameController{
    stepsRemaining--;
    
    [delegate stepsUpdated:self In:gameController];
    
    if (stepsRemaining <= 0){
        [gameController removeActor:anActor];
    }
}
@end
