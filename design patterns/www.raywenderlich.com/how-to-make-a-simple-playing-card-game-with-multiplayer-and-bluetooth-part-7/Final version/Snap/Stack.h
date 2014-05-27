
@class Card;

@interface Stack : NSObject

- (void)addCardToTop:(Card *)card;
- (void)addCardToBottom:(Card *)card;
- (NSUInteger)cardCount;
- (Card *)cardAtIndex:(NSUInteger)index;
- (Card *)topmostCard;
- (void)removeTopmostCard;
- (void)removeAllCards;
- (NSArray *)array;
- (void)addCardsFromArray:(NSArray *)array;

@end
