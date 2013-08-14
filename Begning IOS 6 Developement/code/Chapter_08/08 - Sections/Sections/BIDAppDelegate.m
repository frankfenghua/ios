//
//  BIDAppDelegate.m
//  Sections
//

#import "BIDAppDelegate.h"

#import "BIDViewController.h"

@implementation BIDAppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    BIDViewController *controller = [[BIDViewController alloc]
                                     initWithNibName:@"BIDViewController"
                                     bundle:nil];
    self.viewController = [[UINavigationController alloc]
                           initWithRootViewController:controller];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
