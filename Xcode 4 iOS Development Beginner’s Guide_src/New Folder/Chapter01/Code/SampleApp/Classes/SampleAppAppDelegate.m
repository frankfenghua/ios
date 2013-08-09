//
//  SampleAppAppDelegate.m
//  SampleApp
//
//  Created by Steven F Daniel on 29/12/10.
//  Copyright 2010 GenieSoft Studios. All rights reserved.
//

#import "SampleAppAppDelegate.h"
#import "SampleAppViewController.h"

@implementation SampleAppAppDelegate


@synthesize window;

@synthesize viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Override point for customization after application launch.
     
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {

    // Save data if appropriate.
}

- (void)dealloc {

    [window release];
    [viewController release];
    [super dealloc];
}

@end
