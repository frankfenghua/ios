//
//  Actor02.m
//  Sample 05
//
//  Created by Lucas Jordan on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Actor02.h"

@implementation Actor02
@synthesize actorId;
@synthesize center;
@synthesize speed;
@synthesize radius;
@synthesize imageName;

-(id)initAt:(CGPoint)aPoint WithRadius:(float)aRadius AndImage:(NSString*)anImageName{
    self = [super init];
    if (self != nil){
        [self setActorId:[NSNumber numberWithLong:nextId++]];
        [self setCenter:aPoint];
        [self setRadius:aRadius];
        [self setImageName:anImageName];
    }
    return self;
}
-(void)step:(Example02Controller*)controller{
    //implemented by subclasses.
}
-(BOOL)overlapsWith: (Actor02*) actor {
	float xdist = abs(self.center.x - actor.center.x);
	float ydist = abs(self.center.y - actor.center.y);
    float distance = sqrtf(xdist*xdist+ydist*ydist);
    return distance < self.radius + actor.radius;
}
@end
