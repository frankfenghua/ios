//
//  SwitchesSlidersSegmentsAppDelegate.h
//  SwitchesSlidersSegments
//
//  Created by Steven F Daniel on 20/12/10.
//  Copyright 2010 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchesSlidersSegmentsViewController;

@interface SwitchesSlidersSegmentsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SwitchesSlidersSegmentsViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet SwitchesSlidersSegmentsViewController *viewController;

@end
