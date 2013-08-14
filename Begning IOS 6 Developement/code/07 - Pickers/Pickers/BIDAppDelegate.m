//
//  BIDAppDelegate.m
//  Pickers
//

#import "BIDAppDelegate.h"

@implementation BIDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [[NSBundle mainBundle] loadNibNamed:@"TabBarController" owner:self options:nil];
    self.window.rootViewController = self.rootController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
