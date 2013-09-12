//
//  Sample_04AppDelegate.m
//  Sample 04
//
//  Created by Lucas Jordan on 4/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Sample_04AppDelegate.h"
#import "CoinsGame.h"

@implementation Sample_04AppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSString* gameArchivePath = [self gameArchivePath];
    CoinsGame* existingGame;
    @try {
        existingGame = [[NSKeyedUnarchiver unarchiveObjectWithFile:gameArchivePath] retain];
    }
    @catch (NSException *exception) {
        existingGame = nil;
    }
    [gameController setPreviousGame:existingGame];
    [existingGame release];
    
    [self.window makeKeyAndVisible];
    return YES;
}

-(NSString*)gameArchivePath{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirPath = [paths objectAtIndex:0];
    return [documentDirPath stringByAppendingPathComponent:@"GameArchive"];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSString* gameArchivePath = [self gameArchivePath];
    [NSKeyedArchiver archiveRootObject:[gameController currentGame] toFile: gameArchivePath];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
