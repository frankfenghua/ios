//
//  SwipeExampleAppDelegate.h
//  SwipeExample
//
//  Created by Steven F Daniel on 15/01/11.
//  Copyright 2011 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwipeExampleViewController;

@interface SwipeExampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SwipeExampleViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SwipeExampleViewController *viewController;

@end
