//
//  BIDAppDelegate.m
//  Presidents
//

#import "BIDAppDelegate.h"

@implementation BIDAppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UISplitViewController *splitViewController =
        (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController =
        [splitViewController.viewControllers lastObject];
    splitViewController.delegate =
        (id)navigationController.topViewController;
    return YES;
}

@end
