//
//  CoreLocationAppDelegate.h
//  CoreLocation
//
//  Created by Steven F Daniel on 3/12/10.
//  Copyright 2010 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CoreLocationViewController;

@interface CoreLocationAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CoreLocationViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet CoreLocationViewController *viewController;

@end
