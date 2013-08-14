//
//  BIDAppDelegate.h
//  View Switcher
//

#import <UIKit/UIKit.h>
@class BIDSwitchViewController;
@interface BIDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) BIDSwitchViewController *switchViewController;

@end
