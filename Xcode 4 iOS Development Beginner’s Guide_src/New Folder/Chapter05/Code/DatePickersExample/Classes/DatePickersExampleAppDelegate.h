//
//  DatePickersExampleAppDelegate.h
//  DatePickersExample
//
//  Created by Steven F Daniel on 21/12/10.
//  Copyright 2010 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatePickersExampleViewController;

@interface DatePickersExampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    DatePickersExampleViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet DatePickersExampleViewController *viewController;

@end
