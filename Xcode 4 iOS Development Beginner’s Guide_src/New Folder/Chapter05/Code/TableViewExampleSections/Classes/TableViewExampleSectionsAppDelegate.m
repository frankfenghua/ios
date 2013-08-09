//
//  TableViewExampleSectionsAppDelegate.m
//  TableViewExampleSections
//
//  Created by Steven F. Daniel on 19/12/10.
//  Copyright 2010 GenieSoft Studios. All rights reserved.
//

#import "TableViewExampleSectionsAppDelegate.h"

@implementation TableViewExampleSectionsAppDelegate


@synthesize window;

@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {

    // Save data if appropriate.
}

- (void)dealloc {

    [window release];
    [navigationController release];
    [super dealloc];
}

@end
