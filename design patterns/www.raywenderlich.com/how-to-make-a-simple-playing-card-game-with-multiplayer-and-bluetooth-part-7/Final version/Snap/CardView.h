
const CGFloat CardWidth;
const CGFloat CardHeight;

@class Card;
@class Player;

@interface CardView : UIView

@property (nonatomic, strong) Card *card;

- (void)animateDealingToPlayer:(Player *)player withDelay:(NSTimeInterval)delay;
- (void)animateTurningOverForPlayer:(Player *)player;
- (void)animateRecycleForPlayer:(Player *)player withDelay:(NSTimeInterval)delay;
- (void)animateCloseAndMoveFromPlayer:(Player *)fromPlayer toPlayer:(Player *)toPlayer withDelay:(NSTimeInterval)delay;
- (void)animatePayCardFromPlayer:(Player *)fromPlayer toPlayer:(Player *)toPlayer;
- (void)animateRemovalAtRoundEndForPlayer:(Player *)player withDelay:(NSTimeInterval)delay;

@end
