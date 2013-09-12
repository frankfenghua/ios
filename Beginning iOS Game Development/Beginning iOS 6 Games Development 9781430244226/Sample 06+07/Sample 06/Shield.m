//
//  Shield.m
//  Sample 06
//
//  Created by Lucas Jordan on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Shield.h"
#import "FollowActor.h"
#import "ExpireAfterTime.h"
#import "Bullet.h"
#import "ImageRepresentation.h"

@implementation Shield


+(id)shieldProtecting:(Actor*)anActor From:(Bullet*)bullet{
    
    
    ImageRepresentation* rep = [ImageRepresentation imageRepWithName:@"shield"];
   
    Shield* shield = [[Shield alloc] initAt:[anActor center] WithRadius:[anActor radius] AndRepresentation:rep];
    
    
    [shield addBehavior: [FollowActor followActor:anActor]];
    [shield addBehavior: [ExpireAfterTime expireAfter:60]];
    
    
    float dx = (bullet.center.x - anActor.center.x);
    float dy = (bullet.center.y - anActor.center.y);
    float theta = -atan(dx/dy);
    
    float rotation;

    
    if (dy > 0){
        rotation = theta + M_PI;
    } else {
        rotation = theta;
    }

    [shield setRotation:rotation];
    
    return shield;
}
-(int)getFrameCountForVariant:(int)aVariant AndState:(int)aState{
    return 0;
}
@end
