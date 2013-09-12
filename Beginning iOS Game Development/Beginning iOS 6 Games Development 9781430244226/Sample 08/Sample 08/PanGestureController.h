//
//  PanGestureController.h
//  Sample 08
//
//  Created by Lucas Jordan on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameController.h"

@interface PanGestureController : GameController{
    NSMutableArray* asteroids;
    int asteroidIndex;
    CGPoint startCenter;
}
@property (nonatomic) float minYValue;
@property (nonatomic) float maxYValue;

-(void)panGesture:(UIPanGestureRecognizer*)panRecognizer;

@end
