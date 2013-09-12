//
//  HealthBar.m
//  Sample 06
//
//  Created by Lucas Jordan on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HealthBar.h"
#import "FollowActor.h"

@implementation HealthBar
@synthesize percent;
@synthesize color;
@synthesize backgroundColor;

+(id)healthBar:(Actor*)anActor{
    
    VectorRepresentation* rep = [VectorRepresentation vectorRepresentation];
    
    HealthBar* healthBar = [[HealthBar alloc] initAt:anActor.center WithRadius:anActor.radius AndRepresentation:rep];
    [rep setDelegate:healthBar];
    
    [healthBar setColor:[UIColor colorWithRed:.4 green:.6 blue:1 alpha:1]];
    [healthBar setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.5]];
    
    FollowActor* follow = [FollowActor followActor:anActor];
    [follow setYOffset:[anActor radius]];
    [healthBar addBehavior:follow];
    return healthBar;
}

-(void)setPercent:(float)aPercent{
    if (percent != aPercent){
        percent = aPercent;
        if (percent < 0){
            percent = 0;
        }
        if (percent > 1){
            percent = 1;
        }
        [self setNeedsViewUpdated:YES];
    }
}
-(void)drawActor:(Actor*)anActor WithContext:(CGContextRef)context InRect:(CGRect)rect{
    self.radius = anActor.radius;
    
    CGContextClearRect(context,rect);
    
    float height = self.radius*.2;
    
    CGRect backgroundArea = CGRectMake(0, self.radius-height/2, self.radius*2, height);
    [self.backgroundColor setFill];
    CGContextFillRect(context, backgroundArea);
    
    CGRect healthArea = CGRectMake(0, self.radius-height/2, self.radius*2*percent, height);
    [self.color setFill];
    CGContextFillRect(context, healthArea);
    
}
@end
