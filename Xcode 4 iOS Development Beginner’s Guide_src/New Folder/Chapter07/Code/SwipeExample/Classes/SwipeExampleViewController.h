//
//  SwipeExampleViewController.h
//  SwipeExample
//
//  Created by Steven F Daniel on 15/01/11.
//  Copyright 2011 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

#define minGestureLength    25  // Define the minimum length that is required to be a swipe.
#define allowableVariance   5   // Define the variance of 5 pixels in length.
#define delayFactor         3   // Define our delay factor before our view resets the background. 

@interface SwipeExampleViewController : UIViewController {
    CGPoint currentStartingPoint;
}

@end
