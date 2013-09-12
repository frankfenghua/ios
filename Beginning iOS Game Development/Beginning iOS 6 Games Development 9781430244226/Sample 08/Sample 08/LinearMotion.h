//
//  LinearMotion.h
//  Sample 06
//
//  Created by Lucas Jordan on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Actor.h"

#define DIRECTION_UP -M_PI/2
#define DIRECTION_DOWN M_PI/2
#define DIRECTION_LEFT M_PI
#define DIRECTION_RIGHT 0

@interface LinearMotion : NSObject <Behavior>{
    float deltaX;
    float deltaY;
}

@property (nonatomic) float speed;
@property (nonatomic) float direction;
@property (nonatomic) BOOL wrap;

+(id)linearMotionInDirection:(float)aDirection AtSpeed:(float)aSpeed;
+(id)linearMotionRandomDirectionAndSpeed;
+(id)linearMotionFromPoint:(CGPoint)start toPoint:(CGPoint)end AtSpeed: (float)speed;
@end
