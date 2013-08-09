//
//  SampleAppAppDelegate.h
//  SampleApp
//
//  Created by Steven F Daniel on 29/12/10.
//  Copyright 2010 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SampleAppViewController;

@interface SampleAppAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SampleAppViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet SampleAppViewController *viewController;

@end
