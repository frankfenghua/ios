
#import "Stack.h"
#import "Card.h"

@implementation Stack
{
	NSMutableArray *_cards;
}

- (id)init
{
	if ((self = [super init]))
	{
		_cards = [NSMutableArray arrayWithCapacity:26];
	}
	return self;
}

- (void)addCardToTop:(Card *)card
{
	NSAssert(card != nil, @"Card cannot be nil");
	NSAssert([_cards indexOfObject:card] == NSNotFound, @"Already have this Card");
	[_cards addObject:card];
}

- (void)addCardToBottom:(Card *)card
{
	NSAssert(card != nil, @"Card cannot be nil");
	NSAssert([_cards indexOfObject:card] == NSNotFound, @"Already have this Card");
	[_cards insertObject:card atIndex:0];
}

- (NSUInteger)cardCount
{
	return [_cards count];
}

- (Card *)cardAtIndex:(NSUInteger)index
{
	return [_cards objectAtIndex:index];
}

- (Card *)topmostCard
{
	return [_cards lastObject];
}

- (void)removeTopmostCard
{
	[_cards removeLastObject];
}

- (void)removeAllCards
{
	[_cards removeAllObjects];
}

- (NSArray *)array
{
	return [_cards copy];
}

- (void)addCardsFromArray:(NSArray *)array
{
	_cards = [array mutableCopy];
}

@end
