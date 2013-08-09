//
//  TapExampleAppDelegate.m
//  TapExample
//
//  Created by Steven F. Daniel on 8/01/11.
//  Copyright 2011 GenieSoft Studios. All rights reserved.
//

#import "TapExampleAppDelegate.h"

#import "TapExampleViewController.h"

@implementation TapExampleAppDelegate


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
