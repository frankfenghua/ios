//
//  BIDAppDelegate.m
//  PinchMe
//

#import "BIDAppDelegate.h"

#import "BIDViewController.h"

@implementation BIDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[BIDViewController alloc] initWithNibName:@"BIDViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
