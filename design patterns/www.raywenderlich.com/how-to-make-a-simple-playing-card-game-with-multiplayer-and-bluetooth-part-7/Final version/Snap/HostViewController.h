
#import "MatchmakingServer.h"

@class HostViewController;

@protocol HostViewControllerDelegate <NSObject>

- (void)hostViewControllerDidCancel:(HostViewController *)controller;
- (void)hostViewController:(HostViewController *)controller didEndSessionWithReason:(QuitReason)reason;
- (void)hostViewController:(HostViewController *)controller startGameWithSession:(GKSession *)session playerName:(NSString *)name clients:(NSArray *)clients;

@end

@interface HostViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MatchmakingServerDelegate>

@property (nonatomic, weak) id <HostViewControllerDelegate> delegate;

@end
