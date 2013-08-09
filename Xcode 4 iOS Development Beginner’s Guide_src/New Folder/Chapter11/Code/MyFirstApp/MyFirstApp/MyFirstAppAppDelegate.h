//
//  MyFirstAppAppDelegate.h
//  MyFirstApp
//
//  Created by Steven F Daniel on 16/03/11.
//  Copyright 2011 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyFirstAppViewController;

@interface MyFirstAppAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet MyFirstAppViewController *viewController;

@end
