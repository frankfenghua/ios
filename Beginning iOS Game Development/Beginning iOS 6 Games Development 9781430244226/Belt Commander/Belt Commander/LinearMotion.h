//
//  LinearMotion.h
//  Sample 06
//
//  Created by Lucas Jordan on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#define DIRECTION_UP -M_PI/2
#define DIRECTION_DOWN M_PI/2
#define DIRECTION_LEFT M_PI
#define DIRECTION_RIGHT 0

#import <Foundation/Foundation.h>
#import "Actor.h"

@class LinearMotion;

@protocol LinearMotionDelegate
-(void)linearMotion:(LinearMotion*)linearMotion stoppedAtPoint:(CGPoint)aPoint;
@end

@interface LinearMotion : NSObject <Behavior>{
    float deltaX;
    float deltaY;
    BOOL informedDelegateAboutStoppingAtPoint;
}

@property (nonatomic) float speed;
@property (nonatomic) float direction;
@property (nonatomic) BOOL wrap;
@property (nonatomic) BOOL stopAtPoint;
@property (nonatomic) CGPoint pointToStopAt;
@property (nonatomic) BOOL stayInRect;
@property (nonatomic) CGRect rectToStayIn;
@property (nonatomic, retain) NSObject<LinearMotionDelegate>* delegate;

+(id)linearMotionInDirection:(float)aDirection AtSpeed:(float)aSpeed;
+(id)linearMotionRandomDirectionAndSpeed;
+(id)linearMotionFromPoint:(CGPoint)start toPoint:(CGPoint)end AtSpeed: (float)speed;

+(BOOL)isActor:(Actor*)anActor atStopAtPoint:(CGPoint)aPoint withSpeed:(float)aSpeed;
@end
