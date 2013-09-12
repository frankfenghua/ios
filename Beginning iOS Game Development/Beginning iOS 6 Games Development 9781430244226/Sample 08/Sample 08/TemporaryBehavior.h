//
//  TemporaryBehavior.h
//  Sample 08
//
//  Created by Lucas Jordan on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Actor.h"

@class TemporaryBehavior;
@protocol TemporaryBehaviorDelegate
-(void)stepsUpdatedOn:(Actor*)anActor By:(TemporaryBehavior*)tempBehavior In:(GameController*)controller;
@end

@interface TemporaryBehavior : NSObject <Behavior>{
    
}
@property (nonatomic) long stepsRemaining;
@property (nonatomic, strong) NSObject<Behavior>* behavior;
@property (nonatomic, strong) NSObject<TemporaryBehaviorDelegate>* delegate;

+(id)temporaryBehavior:(NSObject<Behavior>*)aBehavior for:(long)aNumberOfSteps;

@end
