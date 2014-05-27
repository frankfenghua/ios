
@class Card;
@class Stack;

typedef enum
{
	PlayerPositionBottom,  // the local user
	PlayerPositionLeft,
	PlayerPositionTop,
	PlayerPositionRight
}
PlayerPosition;

@interface Player : NSObject

@property (nonatomic, assign) PlayerPosition position;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *peerID;
@property (nonatomic, assign) BOOL receivedResponse;
@property (nonatomic, assign) int lastPacketNumberReceived;
@property (nonatomic, assign) int gamesWon;

@property (nonatomic, strong, readonly) Stack *closedCards;
@property (nonatomic, strong, readonly) Stack *openCards;

- (Card *)turnOverTopCard;
- (BOOL)shouldRecycle;
- (NSArray *)recycleCards;
- (int)totalCardCount;
- (Card *)giveTopmostClosedCardToPlayer:(Player *)otherPlayer;
- (NSArray *)giveAllOpenCardsToPlayer:(Player *)otherPlayer;

@end
