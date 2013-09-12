//
//  MatchActorPosition.m
//  Sample 06
//
//  Created by Lucas Jordan on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FollowActor.h"
#import "GameController.h"

@implementation FollowActor
@synthesize actorToFollow;
@synthesize xOffset;
@synthesize yOffset;

+(id)followActor:(Actor*)anActorToFollow{
    FollowActor* follow = [FollowActor new];
    [follow setActorToFollow:anActorToFollow];
    return follow;
}
-(void)applyToActor:(Actor*)anActor In:(GameController*)gameController{
    if (![actorToFollow removed]){
        CGPoint c = [actorToFollow center];
        c.x += xOffset;
        c.y += yOffset;
        
        [anActor setCenter: c];
    } else {
        [gameController removeActor:anActor];
    }
}

@end
