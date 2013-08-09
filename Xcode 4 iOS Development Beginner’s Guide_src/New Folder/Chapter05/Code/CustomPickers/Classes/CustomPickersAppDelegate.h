//
//  CustomPickersAppDelegate.h
//  CustomPickers
//
//  Created by Steven F Daniel on 21/12/10.
//  Copyright 2010 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomPickersViewController;

@interface CustomPickersAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CustomPickersViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet CustomPickersViewController *viewController;

@end
