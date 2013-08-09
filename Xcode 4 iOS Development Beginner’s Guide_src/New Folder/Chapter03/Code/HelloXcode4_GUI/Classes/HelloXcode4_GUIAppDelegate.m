//
//  HelloXcode4_GUIAppDelegate.m
//  HelloXcode4_GUI
//
//  Created by Steven F Daniel on 13/11/10.
//  Copyright (c) 2010 GenieSoft Studios. All rights reserved.
//

#import "HelloXcode4_GUIAppDelegate.h"

#import "HelloXcode4_GUIViewController.h"

@implementation HelloXcode4_GUIAppDelegate

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
