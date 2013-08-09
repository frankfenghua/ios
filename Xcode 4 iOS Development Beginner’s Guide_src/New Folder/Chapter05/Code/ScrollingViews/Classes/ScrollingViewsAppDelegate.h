//
//  ScrollingViewsAppDelegate.h
//  ScrollingViews
//
//  Created by Steven F Daniel on 19/12/10.
//  Copyright 2010 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScrollingViewsViewController;

@interface ScrollingViewsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ScrollingViewsViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet ScrollingViewsViewController *viewController;

@end
