//
//  LinearMotion.m
//  Sample 06
//
//  Created by Lucas Jordan on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LinearMotion.h"
#import "GameController.h"

@implementation LinearMotion 
@synthesize speed;
@synthesize direction;
@synthesize wrap;


+(id)linearMotionInDirection:(float)aDirection AtSpeed:(float)aSpeed{
    LinearMotion* motion = [LinearMotion new];
    [motion setDirection:aDirection];
    [motion setSpeed:aSpeed];
    
    return motion;
}
+(id)linearMotionRandomDirectionAndSpeed{
    float direction = (arc4random()%100/100.0)*M_PI*2;
    float speed = (arc4random()%100/100.0)*3;
    
    return [LinearMotion linearMotionInDirection:direction AtSpeed:speed];
}
-(void)setSpeed:(float)aSpeed{
    speed = aSpeed;
    deltaX = cosf(direction)*speed;
    deltaY = sinf(direction)*speed;
}
-(void)setDirection:(float)aDirection{
    direction = aDirection;
    deltaX = cosf(direction)*speed;
    deltaY = sinf(direction)*speed;
}

-(void)applyToActor:(Actor*)anActor In:(GameController*)gameController{
    CGPoint center = anActor.center;
    center.x += deltaX;
    center.y += deltaY;
    
    if (wrap){
        CGSize gameSize = [gameController gameAreaSize];
        float radius = [anActor radius];
        
        if (center.x < -radius && deltaX < 0){
            center.x = gameSize.width + radius;
        } else if (center.x > gameSize.width + radius && deltaX > 0){
            center.x = -radius;
        }
        
        if (center.y < -radius && deltaY < 0){
            center.y = gameSize.height + radius;
        } else if (center.y > gameSize.height + radius && deltaY > 0){
            center.y = -radius;
        }
    }
    [anActor setCenter:center];
}

@end
