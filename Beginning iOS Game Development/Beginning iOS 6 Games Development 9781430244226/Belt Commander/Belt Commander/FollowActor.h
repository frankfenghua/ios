//
//  MatchActorPosition.h
//  Sample 06
//
//  Created by Lucas Jordan on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Actor.h"

@interface FollowActor : NSObject <Behavior> {
    
}
@property (nonatomic, retain) Actor* actorToFollow;
@property (nonatomic) float xOffset;
@property (nonatomic) float yOffset;

+(id)followActor:(Actor*)anActorToFollow;

@end
