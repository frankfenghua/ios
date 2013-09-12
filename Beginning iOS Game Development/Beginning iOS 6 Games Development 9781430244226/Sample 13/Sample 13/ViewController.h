//
//  ViewController.h
//  Sample 13
//
//  Created by Lucas Jordan on 8/13/12.
//  Copyright (c) 2012 Lucas Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Box2D/Box2D.h>
#import <QuartzCore/QuartzCore.h>

#define PTM_RATIO 16

@interface ViewController : UIViewController <UIAccelerometerDelegate> {
    b2World* world;
    
    BOOL isInitialInterfaceOrientationSet;
}

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) BOOL isInitialInterfaceOrientationSet;

- (void)startSimulation;
- (void)stopSimulation;

- (void)createPhysicsWorld;
- (void)addPhysicalBodyForView:(UIView *)physicalView;
- (void)update:(CADisplayLink *)sender;

@end
