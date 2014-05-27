
@class Card;

@interface Deck : NSObject

- (void)shuffle;
- (Card *)draw;
- (int)cardsRemaining;

@end
