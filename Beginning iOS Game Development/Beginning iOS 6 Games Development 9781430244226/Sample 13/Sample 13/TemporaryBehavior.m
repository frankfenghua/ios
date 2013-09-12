//
//  TemporaryBehavior.m
//  Sample 08
//
//  Created by Lucas Jordan on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TemporaryBehavior.h"

@implementation TemporaryBehavior
@synthesize stepsRemaining;
@synthesize behavior;
@synthesize delegate;

+(id)temporaryBehavior:(NSObject<Behavior>*)aBehavior for:(long)aNumberOfSteps{
    TemporaryBehavior* temp = [TemporaryBehavior new];
    [temp setBehavior:aBehavior];
    [temp setStepsRemaining:aNumberOfSteps];
    
    return temp;
}
-(void)applyToActor:(Actor*)anActor In:(GameController*)gameController{
    stepsRemaining--;
    
    [behavior applyToActor:anActor In:gameController];
    [delegate stepsUpdatedOn:anActor By:self In:gameController];
    
    
    if (stepsRemaining <= 0){
        [[anActor behaviors] removeObject:self];
    }
}

@end
