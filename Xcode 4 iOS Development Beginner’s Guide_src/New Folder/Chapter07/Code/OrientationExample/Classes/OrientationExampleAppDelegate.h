//
//  OrientationExampleAppDelegate.h
//  OrientationExample
//
//  Created by Steven F Daniel on 16/01/11.
//  Copyright 2011 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrientationExampleViewController;

@interface OrientationExampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    OrientationExampleViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet OrientationExampleViewController *viewController;

@end
