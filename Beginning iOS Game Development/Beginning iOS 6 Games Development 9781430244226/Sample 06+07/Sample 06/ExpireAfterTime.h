//
//  ExpireAfterTime.h
//  Sample 06
//
//  Created by Lucas Jordan on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Actor.h"

@class ExpireAfterTime;
@protocol ExpireAfterTimeDelegate
-(void)stepsUpdated:(ExpireAfterTime*)expire In:(GameController*)controller;
@end


@interface ExpireAfterTime : NSObject <Behavior> {

}
@property (nonatomic) long stepsRemaining;
@property (nonatomic, unsafe_unretained) Actor<ExpireAfterTimeDelegate>* delegate;

+(id)expireAfter:(long)aNumberOfSteps;
@end
