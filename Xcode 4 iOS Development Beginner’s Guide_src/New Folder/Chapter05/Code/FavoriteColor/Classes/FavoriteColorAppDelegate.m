//
//  FavoriteColorAppDelegate.m
//  FavoriteColor
//
//  Created by GENIESOFT-MACBOOK on 19/12/10.
//  Copyright 2010 GENIESOFT STUDIOS. All rights reserved.
//

#import "FavoriteColorAppDelegate.h"

#import "FavoriteColorViewController.h"

@implementation FavoriteColorAppDelegate


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
