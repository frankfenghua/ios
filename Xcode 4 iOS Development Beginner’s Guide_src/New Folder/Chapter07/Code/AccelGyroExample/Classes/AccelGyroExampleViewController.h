//
//  AccelGyroExampleViewController.h
//  AccelGyroExample
//
//  Created by Steven F Daniel on 16/01/11.
//  Copyright 2011 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface AccelGyroExampleViewController : UIViewController <UIAccelerometerDelegate>{
    CMMotionManager *motionManager;
}

@property (nonatomic, retain) CMMotionManager *motionManager;

@end