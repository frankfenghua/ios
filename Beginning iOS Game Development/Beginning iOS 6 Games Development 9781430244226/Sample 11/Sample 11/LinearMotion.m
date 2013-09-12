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

@synthesize stopAtPoint;
@synthesize pointToStopAt;
@synthesize stayInRect;
@synthesize rectToStayIn;

@synthesize delegate;

+(id)linearMotionFromPoint:(CGPoint)start toPoint:(CGPoint)end AtSpeed: (float)speed{
    
    float dx = start.x - end.x;
    float dy = start.y - end.y;
    float direction = atanf(dy/dx);
    if (dx >= 0){
        direction += M_PI;
    }
    
    LinearMotion* motion = [LinearMotion new];
    [motion setDirection: direction];
    [motion setSpeed:speed];
    
    return motion;
}
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
+(BOOL)isActor:(Actor*)anActor atStopAtPoint:(CGPoint)aPoint withSpeed:(float)aSpeed{
    CGPoint actorCenter = [anActor center];
    
    float dx = actorCenter.x - aPoint.x;
    float dy = actorCenter.y - aPoint.y;
    
    float distance = fabsf(sqrtf(dx*dx + dy*dy));
    return fabsf(aSpeed*1.2) > distance;
}
+(BOOL)wouldActor:(Actor*)anActor exitRect:(CGRect)aRect byApplying:(float)deltaX and:(float)deltaY{
    CGPoint center = anActor.center;
    center.x += deltaX;
    center.y += deltaY;
    
    return !CGRectContainsPoint(aRect, center);
}
-(void)applyToActor:(Actor*)anActor In:(GameController*)gameController{
    
    if (stopAtPoint && [LinearMotion isActor:anActor atStopAtPoint:pointToStopAt withSpeed:speed]){
        [anActor setCenter:pointToStopAt];
        if (!informedDelegateAboutStoppingAtPoint){
            [delegate linearMotion:self stoppedAtPoint:pointToStopAt];
            informedDelegateAboutStoppingAtPoint = YES;
        }
    } else if (!stayInRect || ![LinearMotion wouldActor:anActor exitRect:rectToStayIn byApplying:deltaX and:deltaY]){
        
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
        
    } else {
       //should set actor's center to the point where the line segment anActor.center -> new center, intersects the rectangle rectToStayIn?
    }
}

@end
