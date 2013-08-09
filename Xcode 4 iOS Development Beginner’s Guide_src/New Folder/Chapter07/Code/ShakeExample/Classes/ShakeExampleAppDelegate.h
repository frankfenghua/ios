//
//  ShakeExampleAppDelegate.h
//  ShakeExample
//
//  Created by Steven F. Daniel on 8/01/11.
//  Copyright 2011 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShakeExampleViewController;

@interface ShakeExampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ShakeExampleViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet ShakeExampleViewController *viewController;

@end
