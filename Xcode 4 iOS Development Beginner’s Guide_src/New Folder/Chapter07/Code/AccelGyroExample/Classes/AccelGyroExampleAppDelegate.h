//
//  AccelGyroExampleAppDelegate.h
//  AccelGyroExample
//
//  Created by Steven F Daniel on 16/01/11.
//  Copyright 2011 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccelGyroExampleViewController;

@interface AccelGyroExampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    AccelGyroExampleViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AccelGyroExampleViewController *viewController;

@end
