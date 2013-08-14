//
//  BIDAppDelegate.m
//  Nav
//

#import "BIDAppDelegate.h"
#import "BIDFirstLevelViewController.h"

@implementation BIDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    BIDFirstLevelViewController *first = [[BIDFirstLevelViewController alloc] init];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:first];
    self.window.rootViewController = navigation;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
