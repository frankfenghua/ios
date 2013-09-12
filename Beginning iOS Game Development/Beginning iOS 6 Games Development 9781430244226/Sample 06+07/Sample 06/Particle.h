//
//  Spark.h
//  Sample 06
//
//  Created by Lucas Jordan on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Actor.h"
#import "ExpireAfterTime.h"

@interface Particle : Actor<ExpireAfterTimeDelegate> {
    
}
@property (nonatomic) float totalStepsAlive;
+(id)particleAt:(CGPoint)aCenter WithRep:(NSObject<Representation>*)rep Steps:(float)numStepsToLive;
@end
