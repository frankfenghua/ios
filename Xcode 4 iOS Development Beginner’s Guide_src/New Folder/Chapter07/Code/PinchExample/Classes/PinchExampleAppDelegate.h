//
//  PinchExampleAppDelegate.h
//  PinchExample
//
//  Created by Steven F Daniel on 15/01/11.
//  Copyright 2011 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PinchExampleViewController;

@interface PinchExampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    PinchExampleViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet PinchExampleViewController *viewController;

@end
