
@class MatchmakingClient;

@protocol MatchmakingClientDelegate <NSObject>

- (void)matchmakingClient:(MatchmakingClient *)client serverBecameAvailable:(NSString *)peerID;
- (void)matchmakingClient:(MatchmakingClient *)client serverBecameUnavailable:(NSString *)peerID;
- (void)matchmakingClient:(MatchmakingClient *)client didConnectToServer:(NSString *)peerID;
- (void)matchmakingClient:(MatchmakingClient *)client didDisconnectFromServer:(NSString *)peerID;
- (void)matchmakingClientNoNetwork:(MatchmakingClient *)client;

@end

@interface MatchmakingClient : NSObject <GKSessionDelegate>

@property (nonatomic, weak) id <MatchmakingClientDelegate> delegate;

@property (nonatomic, strong, readonly) NSArray *availableServers;
@property (nonatomic, strong, readonly) GKSession *session;

- (void)startSearchingForServersWithSessionID:(NSString *)sessionID;

- (NSUInteger)availableServerCount;
- (NSString *)peerIDForAvailableServerAtIndex:(NSUInteger)index;
- (NSString *)displayNameForPeerID:(NSString *)peerID;

- (void)connectToServerWithPeerID:(NSString *)peerID;
- (void)disconnectFromServer;

@end
