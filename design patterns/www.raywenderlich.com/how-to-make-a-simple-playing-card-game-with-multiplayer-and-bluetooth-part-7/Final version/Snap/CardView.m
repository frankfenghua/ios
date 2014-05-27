
#import "CardView.h"
#import "Card.h"
#import "Player.h"

const CGFloat CardWidth = 67.0f;   // this includes the drop shadows
const CGFloat CardHeight = 99.0f;

@implementation CardView
{
	UIImageView *_backImageView;
	UIImageView *_frontImageView;
	CGFloat _angle;
}

@synthesize card = _card;

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		self.backgroundColor = [UIColor clearColor];
		[self loadBack];
	}
	return self;
}

- (void)loadBack
{
	if (_backImageView == nil)
	{
		_backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
		_backImageView.image = [UIImage imageNamed:@"Back"];
		_backImageView.contentMode = UIViewContentModeScaleToFill;
		[self addSubview:_backImageView];
	}
}

- (void)unloadBack
{
	[_backImageView removeFromSuperview];
	_backImageView = nil;
}

- (void)loadFront
{
	if (_frontImageView == nil)
	{
		_frontImageView = [[UIImageView alloc] initWithFrame:self.bounds];
		_frontImageView.contentMode = UIViewContentModeScaleToFill;
		_frontImageView.hidden = YES;
		[self addSubview:_frontImageView];

		NSString *suitString;
		switch (self.card.suit)
		{
			case SuitClubs:    suitString = @"Clubs"; break;
			case SuitDiamonds: suitString = @"Diamonds"; break;
			case SuitHearts:   suitString = @"Hearts"; break;
			case SuitSpades:   suitString = @"Spades"; break;
		}

		NSString *valueString;
		switch (self.card.value)
		{
			case CardAce:   valueString = @"Ace"; break;
			case CardJack:  valueString = @"Jack"; break;
			case CardQueen: valueString = @"Queen"; break;
			case CardKing:  valueString = @"King"; break;
			default:        valueString = [NSString stringWithFormat:@"%d", self.card.value];
		}

		NSString *filename = [NSString stringWithFormat:@"%@ %@", suitString, valueString];
		_frontImageView.image = [UIImage imageNamed:filename];
	}
}

- (void)unloadFront
{
	[_frontImageView removeFromSuperview];
	_frontImageView = nil;
}

- (CGPoint)centerForPlayer:(Player *)player
{
	CGRect rect = self.superview.bounds;
	CGFloat midX = CGRectGetMidX(rect);
	CGFloat midY = CGRectGetMidY(rect);
	CGFloat maxX = CGRectGetMaxX(rect);
	CGFloat maxY = CGRectGetMaxY(rect);

	CGFloat x = -3.0f + RANDOM_INT(6) + CardWidth/2.0f;
	CGFloat y = -3.0f + RANDOM_INT(6) + CardHeight/2.0f;

	if (self.card.isTurnedOver)
	{
		if (player.position == PlayerPositionBottom)
		{
			x += midX + 7.0f;
			y += maxY - CardHeight - 30.0f;
		}
		else if (player.position == PlayerPositionLeft)
		{
			x += 31.0f;
			y += midY - 30.0f;
		}
		else if (player.position == PlayerPositionTop)
		{
			x += midX - CardWidth - 7.0f;
			y += 29.0f;
		}
		else
		{
			x += maxX - CardHeight + 1.0f;
			y += midY - CardWidth - 45.0f;
		}	
	}
	else
	{
		if (player.position == PlayerPositionBottom)
		{
			x += midX - CardWidth - 7.0f;
			y += maxY - CardHeight - 30.0f;
		}
		else if (player.position == PlayerPositionLeft)
		{
			x += 31.0f;
			y += midY - CardWidth - 45.0f;
		}
		else if (player.position == PlayerPositionTop)
		{
			x += midX + 7.0f;
			y += 29.0f;
		}
		else
		{
			x += maxX - CardHeight + 1.0f;
			y += midY - 30.0f;
		}
	}

	return CGPointMake(x, y);
}

- (CGFloat)angleForPlayer:(Player *)player
{
	float theAngle = (-0.5f + RANDOM_FLOAT()) / 4.0f;

	if (player.position == PlayerPositionLeft)
		theAngle += M_PI / 2.0f;
	else if (player.position == PlayerPositionTop)
		theAngle += M_PI;
	else if (player.position == PlayerPositionRight)
		theAngle -= M_PI / 2.0f;

	return theAngle;
}

- (void)animateDealingToPlayer:(Player *)player withDelay:(NSTimeInterval)delay
{
	self.frame = CGRectMake(-100.0f, -100.0f, CardWidth, CardHeight);
	self.transform = CGAffineTransformMakeRotation(M_PI);

	CGPoint point = [self centerForPlayer:player];
	_angle = [self angleForPlayer:player];

	[UIView animateWithDuration:0.2f
		delay:delay
		options:UIViewAnimationOptionCurveEaseOut
		animations:^
		{
			self.center = point;
			self.transform = CGAffineTransformMakeRotation(_angle);
		}
		completion:nil];
}

- (void)animateTurningOverForPlayer:(Player *)player
{
	[self loadFront];
	[self.superview bringSubviewToFront:self];

	UIImageView *darkenView = [[UIImageView alloc] initWithFrame:self.bounds];
	darkenView.backgroundColor = [UIColor clearColor];
	darkenView.image = [UIImage imageNamed:@"Darken"];
	darkenView.alpha = 0.0f;
	[self addSubview:darkenView];

	CGPoint startPoint = self.center;
	CGPoint endPoint = [self centerForPlayer:player];
	CGFloat afterAngle = [self angleForPlayer:player];

	CGPoint halfwayPoint = CGPointMake((startPoint.x + endPoint.x)/2.0f, (startPoint.y + endPoint.y)/2.0f);
	CGFloat halfwayAngle = (_angle + afterAngle)/2.0f;

	[UIView animateWithDuration:0.15f
		delay:0.0f
		options:UIViewAnimationOptionCurveEaseIn
		animations:^
		{
			CGRect rect = _backImageView.bounds;
			rect.size.width = 1.0f;
			_backImageView.bounds = rect;

			darkenView.bounds = rect;
			darkenView.alpha = 0.5f;

			self.center = halfwayPoint;
			self.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(halfwayAngle), 1.2f, 1.2f);
		}
		completion:^(BOOL finished)
		{
			_frontImageView.bounds = _backImageView.bounds;
			_frontImageView.hidden = NO;

			[UIView animateWithDuration:0.15f
				delay:0
				options:UIViewAnimationOptionCurveEaseOut
				animations:^
				{
					CGRect rect = _frontImageView.bounds;
					rect.size.width = CardWidth;
					_frontImageView.bounds = rect;

					darkenView.bounds = rect;
					darkenView.alpha = 0.0f;

					self.center = endPoint;
					self.transform = CGAffineTransformMakeRotation(afterAngle);
				}
				completion:^(BOOL finished)
				{
					[darkenView removeFromSuperview];
					[self unloadBack];
				}];
		}];
}

- (void)animateRecycleForPlayer:(Player *)player withDelay:(NSTimeInterval)delay
{
	[self.superview sendSubviewToBack:self];

	[self unloadFront];
	[self loadBack];

	[UIView animateWithDuration:0.2f
		delay:delay
		options:UIViewAnimationOptionCurveEaseOut
		animations:^
		{
			self.center = [self centerForPlayer:player];
		}
		completion:nil];
}

- (void)animateCloseAndMoveFromPlayer:(Player *)fromPlayer toPlayer:(Player *)toPlayer withDelay:(NSTimeInterval)delay
{
	[self.superview sendSubviewToBack:self];

	[self unloadFront];
	[self loadBack];

	CGPoint point = [self centerForPlayer:toPlayer];
	_angle = [self angleForPlayer:toPlayer];

	[UIView animateWithDuration:0.4f
		delay:delay
		options:UIViewAnimationOptionCurveEaseOut
		animations:^
		{
			self.center = point;
			self.transform = CGAffineTransformMakeRotation(_angle);
		}
		completion:nil];
}

- (void)animatePayCardFromPlayer:(Player *)fromPlayer toPlayer:(Player *)toPlayer
{
	[self.superview sendSubviewToBack:self];

	CGPoint point = [self centerForPlayer:toPlayer];
	_angle = [self angleForPlayer:toPlayer];

	[UIView animateWithDuration:0.4f
		delay:0.0f
		options:UIViewAnimationOptionCurveEaseOut
		animations:^
		{
			self.center = point;
			self.transform = CGAffineTransformMakeRotation(_angle);
		}
		completion:nil];
}

- (void)animateRemovalAtRoundEndForPlayer:(Player *)player withDelay:(NSTimeInterval)delay
{
	[UIView animateWithDuration:0.2f
		delay:delay
		options:UIViewAnimationOptionCurveEaseIn
		animations:^
		{
			self.center = CGPointMake(self.center.x, self.superview.bounds.size.height + CardHeight);
		}
		completion:^(BOOL finished)
		{
			[self removeFromSuperview];
		}];
}

@end
