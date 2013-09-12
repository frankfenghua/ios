//
//  Actor03.m
//  Sample 05
//
//  Created by Lucas Jordan on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Actor03.h"


@implementation Actor03
@synthesize actorId;
@synthesize center;
@synthesize rotation;
@synthesize speed;
@synthesize radius;
@synthesize imageName;
@synthesize needsImageUpdated;

-(id)initAt:(CGPoint)aPoint WithRadius:(float)aRadius AndImage:(NSString*)anImageName{
    self = [super init];
    if (self != nil){
        [self setActorId:[NSNumber numberWithLong:nextId++]];
        [self setCenter:aPoint];
        [self setRotation:0];
        [self setRadius:aRadius];
        [self setImageName:anImageName];
    }
    return self;
}
-(void)step:(Example03Controller*)controller{
    //implemented by subclasses.
}
-(BOOL)overlapsWith: (Actor03*) actor {
	float xdist = abs(self.center.x - actor.center.x);
	float ydist = abs(self.center.y - actor.center.y);
    float distance = sqrtf(xdist*xdist+ydist*ydist);
    return distance < self.radius + actor.radius;
}
@end