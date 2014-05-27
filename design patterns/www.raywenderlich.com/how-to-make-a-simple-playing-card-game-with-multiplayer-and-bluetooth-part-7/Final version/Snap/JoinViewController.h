
#import "MatchmakingClient.h"

@class JoinViewController;

@protocol JoinViewControllerDelegate <NSObject>

- (void)joinViewControllerDidCancel:(JoinViewController *)controller;
- (void)joinViewController:(JoinViewController *)controller didDisconnectWithReason:(QuitReason)reason;
- (void)joinViewController:(JoinViewController *)controller startGameWithSession:(GKSession *)session playerName:(NSString *)name server:(NSString *)peerID;

@end

@interface JoinViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MatchmakingClientDelegate>

@property (nonatomic, weak) id <JoinViewControllerDelegate> delegate;

@end
