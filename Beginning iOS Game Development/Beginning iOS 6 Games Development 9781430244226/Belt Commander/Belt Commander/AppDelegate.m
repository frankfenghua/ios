//
//  AppDelegate.m
//  Belt Commander
//
//  Created by Lucas Jordan on 8/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    UIWindow* window = [application.windows objectAtIndex:0];
    RootViewController* rvc = (RootViewController*)[window rootViewController];
    [rvc applicationWillResignActive];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    UIWindow* window = [application.windows objectAtIndex:0];
    RootViewController* rvc = (RootViewController*)[window rootViewController];
    [rvc doPause];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    UIWindow* window = [application.windows objectAtIndex:0];
    RootViewController* rvc = (RootViewController*)[window rootViewController];
    [rvc applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
