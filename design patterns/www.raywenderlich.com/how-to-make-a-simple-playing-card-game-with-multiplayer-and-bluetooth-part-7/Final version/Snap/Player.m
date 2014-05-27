
#import "Player.h"
#import "Card.h"
#import "Stack.h"

@implementation Player

@synthesize position = _position;
@synthesize name = _name;
@synthesize peerID = _peerID;
@synthesize receivedResponse = _receivedResponse;
@synthesize lastPacketNumberReceived = _lastPacketNumberReceived;
@synthesize gamesWon = _gamesWon;

@synthesize closedCards = _closedCards;
@synthesize openCards = _openCards;

- (id)init
{
	if ((self = [super init]))
	{
		_lastPacketNumberReceived = -1;
		_closedCards = [[Stack alloc] init];
		_openCards = [[Stack alloc] init];
	}
	return self;
}

- (void)dealloc
{
	#ifdef DEBUG
	NSLog(@"dealloc %@", self);
	#endif
}

- (Card *)turnOverTopCard
{
	NSAssert([self.closedCards cardCount] > 0, @"No more cards");

	Card *card = [self.closedCards topmostCard];
	card.isTurnedOver = YES;
	[self.openCards addCardToTop:card];
	[self.closedCards removeTopmostCard];

	return card;
}

- (BOOL)shouldRecycle
{
	return ([self.closedCards cardCount] == 0) && ([self.openCards cardCount] > 1);
}

- (NSArray *)recycleCards
{
	return [self giveAllOpenCardsToPlayer:self];
}

- (NSArray *)giveAllOpenCardsToPlayer:(Player *)otherPlayer
{
	NSUInteger count = [self.openCards cardCount];
	NSMutableArray *movedCards = [NSMutableArray arrayWithCapacity:count];

	for (NSUInteger t = 0; t < count; ++t)
	{
		Card *card = [self.openCards cardAtIndex:t];
		card.isTurnedOver = NO;
		[otherPlayer.closedCards addCardToBottom:card];
		[movedCards addObject:card];
	}

	[self.openCards removeAllCards];
	return movedCards;
}

- (int)totalCardCount
{
	return [self.closedCards cardCount] + [self.openCards cardCount];
}

- (Card *)giveTopmostClosedCardToPlayer:(Player *)otherPlayer
{
	Card *card = [self.closedCards topmostCard];
	if (card != nil)
	{
		[otherPlayer.closedCards addCardToBottom:card];
		[self.closedCards removeTopmostCard];
	}
	return card;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ peerID = %@, name = %@, position = %d", [super description], self.peerID, self.name, self.position];
}

@end
