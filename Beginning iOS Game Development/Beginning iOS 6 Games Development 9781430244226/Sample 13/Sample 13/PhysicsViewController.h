//
//  PhysicsViewController.h
//  Sample 13
//
//  Created by Lucas Jordan on 8/23/12.
//  Copyright (c) 2012 Lucas Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Box2D/Box2D.h>
#import <QuartzCore/QuartzCore.h>
#import "GameController.h"

@interface PhysicsViewController : GameController{
    b2World* world;
}
+(CGPoint)convertPointToCG:(b2Vec2)position;
+(b2Vec2)convertPointToB2:(CGPoint)point;
+(float)convertDisntanceToGC:(float)distance;
+(float)convertDistanceToB2:(float)distance;
@end
