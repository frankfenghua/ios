
#import "GameViewController.h"
#import "Game.h"
#import "Card.h"
#import "CardView.h"
#import "Player.h"
#import "Stack.h"
#import "UIFont+SnapAdditions.h"

@interface GameViewController ()

@property (nonatomic, weak) IBOutlet UILabel *centerLabel;

@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, weak) IBOutlet UIView *cardContainerView;
@property (nonatomic, weak) IBOutlet UIButton *turnOverButton;
@property (nonatomic, weak) IBOutlet UIButton *snapButton;
@property (nonatomic, weak) IBOutlet UIButton *nextRoundButton;
@property (nonatomic, weak) IBOutlet UIImageView *wrongSnapImageView;
@property (nonatomic, weak) IBOutlet UIImageView *correctSnapImageView;

@property (nonatomic, weak) IBOutlet UILabel *playerNameBottomLabel;
@property (nonatomic, weak) IBOutlet UILabel *playerNameLeftLabel;
@property (nonatomic, weak) IBOutlet UILabel *playerNameTopLabel;
@property (nonatomic, weak) IBOutlet UILabel *playerNameRightLabel;

@property (nonatomic, weak) IBOutlet UILabel *playerWinsBottomLabel;
@property (nonatomic, weak) IBOutlet UILabel *playerWinsLeftLabel;
@property (nonatomic, weak) IBOutlet UILabel *playerWinsTopLabel;
@property (nonatomic, weak) IBOutlet UILabel *playerWinsRightLabel;

@property (nonatomic, weak) IBOutlet UIImageView *playerActiveBottomImageView;
@property (nonatomic, weak) IBOutlet UIImageView *playerActiveLeftImageView;
@property (nonatomic, weak) IBOutlet UIImageView *playerActiveTopImageView;
@property (nonatomic, weak) IBOutlet UIImageView *playerActiveRightImageView;

@property (nonatomic, weak) IBOutlet UIImageView *snapIndicatorBottomImageView;
@property (nonatomic, weak) IBOutlet UIImageView *snapIndicatorLeftImageView;
@property (nonatomic, weak) IBOutlet UIImageView *snapIndicatorTopImageView;
@property (nonatomic, weak) IBOutlet UIImageView *snapIndicatorRightImageView;

@end

@implementation GameViewController
{
	UIAlertView *_alertView;
	UIImageView *_tappedView;
	AVAudioPlayer *_dealingCardsSound;
	AVAudioPlayer *_turnCardSound;
	AVAudioPlayer *_wrongMatchSound;
	AVAudioPlayer *_correctMatchSound;
}

@synthesize delegate = _delegate;
@synthesize game = _game;

@synthesize centerLabel = _centerLabel;

@synthesize backgroundImageView = _backgroundImageView;
@synthesize cardContainerView = _cardContainerView;
@synthesize turnOverButton = _turnOverButton;
@synthesize snapButton = _snapButton;
@synthesize nextRoundButton = _nextRoundButton;
@synthesize wrongSnapImageView = _wrongSnapImageView;
@synthesize correctSnapImageView = _correctSnapImageView;

@synthesize playerNameBottomLabel = _playerNameBottomLabel;
@synthesize playerNameLeftLabel = _playerNameLeftLabel;
@synthesize playerNameTopLabel = _playerNameTopLabel;
@synthesize playerNameRightLabel = _playerNameRightLabel;

@synthesize playerWinsBottomLabel = _playerWinsBottomLabel;
@synthesize playerWinsLeftLabel = _playerWinsLeftLabel;
@synthesize playerWinsTopLabel = _playerWinsTopLabel;
@synthesize playerWinsRightLabel = _playerWinsRightLabel;

@synthesize playerActiveBottomImageView = _playerActiveBottomImageView;
@synthesize playerActiveLeftImageView = _playerActiveLeftImageView;
@synthesize playerActiveTopImageView = _playerActiveTopImageView;
@synthesize playerActiveRightImageView = _playerActiveRightImageView;

@synthesize snapIndicatorBottomImageView = _snapIndicatorBottomImageView;
@synthesize snapIndicatorLeftImageView = _snapIndicatorLeftImageView;
@synthesize snapIndicatorTopImageView = _snapIndicatorTopImageView;
@synthesize snapIndicatorRightImageView = _snapIndicatorRightImageView;

- (void)dealloc
{
	#ifdef DEBUG
	NSLog(@"dealloc %@", self);
	#endif

	[_dealingCardsSound stop];
	[[AVAudioSession sharedInstance] setActive:NO error:NULL];
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.centerLabel.font = [UIFont rw_snapFontWithSize:18.0f];

	self.snapButton.hidden = YES;
	self.nextRoundButton.hidden = YES;
	self.wrongSnapImageView.hidden = YES;
	self.correctSnapImageView.hidden = YES;

	[self hidePlayerLabels];
	[self hideActivePlayerIndicator];
	[self hideSnapIndicators];
	[self loadSounds];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

	[_alertView dismissWithClickedButtonIndex:_alertView.cancelButtonIndex animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)loadSounds
{
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	audioSession.delegate = nil;
	[audioSession setCategory:AVAudioSessionCategoryAmbient error:NULL];
	[audioSession setActive:YES error:NULL];

	NSURL *url = [[NSBundle mainBundle] URLForResource:@"Dealing" withExtension:@"caf"];
	_dealingCardsSound = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	_dealingCardsSound.numberOfLoops = -1;
	[_dealingCardsSound prepareToPlay];

	url = [[NSBundle mainBundle] URLForResource:@"TurnCard" withExtension:@"caf"];
	_turnCardSound = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	[_turnCardSound prepareToPlay];

	url = [[NSBundle mainBundle] URLForResource:@"WrongMatch" withExtension:@"caf"];
	_wrongMatchSound = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	[_wrongMatchSound prepareToPlay];

	url = [[NSBundle mainBundle] URLForResource:@"CorrectMatch" withExtension:@"caf"];
	_correctMatchSound = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	[_correctMatchSound prepareToPlay];
}

#pragma mark - Game UI

- (CardView *)cardViewForCard:(Card *)card
{
	for (CardView *cardView in self.cardContainerView.subviews)
	{
		if ([cardView.card isEqualToCard:card])
			return cardView;
	}
	return nil;
}

- (void)resizeLabelToFit:(UILabel *)label
{
	[label sizeToFit];

	CGRect rect = label.frame;
	rect.size.width = ceilf(rect.size.width/2.0f) * 2.0f;  // make even
	rect.size.height = ceilf(rect.size.height/2.0f) * 2.0f;  // make even
	label.frame = rect;
}

- (void)calculateLabelFrames
{
	UIFont *font = [UIFont rw_snapFontWithSize:14.0f];
	self.playerNameBottomLabel.font = font;
	self.playerNameLeftLabel.font = font;
	self.playerNameTopLabel.font = font;
	self.playerNameRightLabel.font = font;

	font = [UIFont rw_snapFontWithSize:11.0f];
	self.playerWinsBottomLabel.font = font;
	self.playerWinsLeftLabel.font = font;
	self.playerWinsTopLabel.font = font;
	self.playerWinsRightLabel.font = font;

	self.playerWinsBottomLabel.layer.cornerRadius = 4.0f;
	self.playerWinsLeftLabel.layer.cornerRadius = 4.0f;
	self.playerWinsTopLabel.layer.cornerRadius = 4.0f;
	self.playerWinsRightLabel.layer.cornerRadius = 4.0f;

	UIImage *image = [[UIImage imageNamed:@"ActivePlayer"] stretchableImageWithLeftCapWidth:20 topCapHeight:0];
	self.playerActiveBottomImageView.image = image;
	self.playerActiveLeftImageView.image = image;
	self.playerActiveTopImageView.image = image;
	self.playerActiveRightImageView.image = image;

	CGFloat viewWidth = self.view.bounds.size.width;
	CGFloat centerX = viewWidth / 2.0f;

	Player *player = [self.game playerAtPosition:PlayerPositionBottom];
	if (player != nil)
	{
		self.playerNameBottomLabel.text = player.name;

		[self resizeLabelToFit:self.playerNameBottomLabel];
		CGFloat labelWidth = self.playerNameBottomLabel.bounds.size.width;

		CGPoint point = CGPointMake(centerX - 19.0f - 3.0f, 306.0f);
		self.playerNameBottomLabel.center = point;

		CGPoint winsPoint = point;
		winsPoint.x += labelWidth/2.0f + 6.0f + 19.0f;
		winsPoint.y -= 0.5f;
		self.playerWinsBottomLabel.center = winsPoint;

		self.playerActiveBottomImageView.frame = CGRectMake(0, 0, 20.0f + labelWidth + 6.0f + 38.0f + 2.0f, 20.0f);

		point.x = centerX - 9.0f;
		self.playerActiveBottomImageView.center = point;
	}

	player = [self.game playerAtPosition:PlayerPositionLeft];
	if (player != nil)
	{
		self.playerNameLeftLabel.text = player.name;
	
		[self resizeLabelToFit:self.playerNameLeftLabel];
		CGFloat labelWidth = self.playerNameLeftLabel.bounds.size.width;

		CGPoint point = CGPointMake(2.0 + 20.0f + labelWidth/2.0f, 48.0f);
		self.playerNameLeftLabel.center = point;

		CGPoint winsPoint = point;
		winsPoint.x += labelWidth/2.0f + 6.0f + 19.0f;
		winsPoint.y -= 0.5f;
		self.playerWinsLeftLabel.center = winsPoint;

		self.playerActiveLeftImageView.frame = CGRectMake(2.0f, 38.0f, 20.0f + labelWidth + 6.0f + 38.0f + 2.0f, 20.0f);
	}

	player = [self.game playerAtPosition:PlayerPositionTop];
	if (player != nil)
	{
		self.playerNameTopLabel.text = player.name;

		[self resizeLabelToFit:self.playerNameTopLabel];
		CGFloat labelWidth = self.playerNameTopLabel.bounds.size.width;

		CGPoint point = CGPointMake(centerX - 19.0f - 3.0f, 15.0f);
		self.playerNameTopLabel.center = point;

		CGPoint winsPoint = point;
		winsPoint.x += labelWidth/2.0f + 6.0f + 19.0f;
		winsPoint.y -= 0.5f;
		self.playerWinsTopLabel.center = winsPoint;

		self.playerActiveTopImageView.frame = CGRectMake(0, 0, 20.0f + labelWidth + 6.0f + 38.0f + 2.0f, 20.0f);

		point.x = centerX - 9.0f;
		self.playerActiveTopImageView.center = point;
	}

	player = [self.game playerAtPosition:PlayerPositionRight];
	if (player != nil)
	{
		self.playerNameRightLabel.text = player.name;

		[self resizeLabelToFit:self.playerNameRightLabel];
		CGFloat labelWidth = self.playerNameRightLabel.bounds.size.width;

		CGPoint point = CGPointMake(viewWidth - labelWidth/2.0f - 2.0f - 6.0f - 38.0f - 12.0f, 48.0f);
		self.playerNameRightLabel.center = point;

		CGPoint winsPoint = point;
		winsPoint.x += labelWidth/2.0f + 6.0f + 19.0f;
		winsPoint.y -= 0.5f;
		self.playerWinsRightLabel.center = winsPoint;

		self.playerActiveRightImageView.frame = CGRectMake(self.playerNameRightLabel.frame.origin.x - 20.0f, 38.0f, 20.0f + labelWidth + 6.0f + 38.0f + 2.0f, 20.0f);
	}
}

- (void)hidePlayerLabels
{
	self.playerNameBottomLabel.hidden = YES;
	self.playerWinsBottomLabel.hidden = YES;

	self.playerNameLeftLabel.hidden = YES;
	self.playerWinsLeftLabel.hidden = YES;

	self.playerNameTopLabel.hidden = YES;
	self.playerWinsTopLabel.hidden = YES;

	self.playerNameRightLabel.hidden = YES;
	self.playerWinsRightLabel.hidden = YES;
}

- (void)hidePlayerLabelsForPlayer:(Player *)player
{
	switch (player.position)
	{
		case PlayerPositionBottom:
			self.playerNameBottomLabel.hidden = YES;
			self.playerWinsBottomLabel.hidden = YES;
			break;
		
		case PlayerPositionLeft:
			self.playerNameLeftLabel.hidden = YES;
			self.playerWinsLeftLabel.hidden = YES;
			break;
		
		case PlayerPositionTop:
			self.playerNameTopLabel.hidden = YES;
			self.playerWinsTopLabel.hidden = YES;
			break;
		
		case PlayerPositionRight:
			self.playerNameRightLabel.hidden = YES;
			self.playerWinsRightLabel.hidden = YES;
			break;
	}
}

- (void)showPlayerLabels
{
	Player *player = [self.game playerAtPosition:PlayerPositionBottom];
	if (player != nil)
	{
		self.playerNameBottomLabel.hidden = NO;
		self.playerWinsBottomLabel.hidden = NO;
	}

	player = [self.game playerAtPosition:PlayerPositionLeft];
	if (player != nil)
	{
		self.playerNameLeftLabel.hidden = NO;
		self.playerWinsLeftLabel.hidden = NO;
	}

	player = [self.game playerAtPosition:PlayerPositionTop];
	if (player != nil)
	{
		self.playerNameTopLabel.hidden = NO;
		self.playerWinsTopLabel.hidden = NO;
	}

	player = [self.game playerAtPosition:PlayerPositionRight];
	if (player != nil)
	{
		self.playerNameRightLabel.hidden = NO;
		self.playerWinsRightLabel.hidden = NO;
	}
}

- (void)hideActivePlayerIndicator
{
	self.playerActiveBottomImageView.hidden = YES;
	self.playerActiveLeftImageView.hidden   = YES;
	self.playerActiveTopImageView.hidden    = YES;
	self.playerActiveRightImageView.hidden  = YES;
}

- (void)hideActiveIndicatorForPlayer:(Player *)player
{
	switch (player.position)
	{
		case PlayerPositionBottom: self.playerActiveBottomImageView.hidden = YES; break;
		case PlayerPositionLeft:   self.playerActiveLeftImageView.hidden   = YES; break;
		case PlayerPositionTop:    self.playerActiveTopImageView.hidden    = YES; break;
		case PlayerPositionRight:  self.playerActiveRightImageView.hidden  = YES; break;
	}
}

- (void)showIndicatorForActivePlayer
{
	[self hideActivePlayerIndicator];

	PlayerPosition position = [self.game activePlayer].position;

	switch (position)
	{
		case PlayerPositionBottom: self.playerActiveBottomImageView.hidden = NO; break;
		case PlayerPositionLeft:   self.playerActiveLeftImageView.hidden   = NO; break;
		case PlayerPositionTop:    self.playerActiveTopImageView.hidden    = NO; break;
		case PlayerPositionRight:  self.playerActiveRightImageView.hidden  = NO; break;
	}

	if (position == PlayerPositionBottom)
		self.centerLabel.text = NSLocalizedString(@"Your turn. Tap the stack.", @"Status text: your turn");
	else
		self.centerLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@'s turn", @"Status text: other player's turn"), [self.game activePlayer].name];
}

- (void)hideSnapIndicators
{
	self.snapIndicatorBottomImageView.hidden = YES;
	self.snapIndicatorLeftImageView.hidden   = YES;
	self.snapIndicatorTopImageView.hidden    = YES;
	self.snapIndicatorRightImageView.hidden  = YES;
}

- (void)hideSnapIndicatorForPlayer:(Player *)player
{
	switch (player.position)
	{
		case PlayerPositionBottom: self.snapIndicatorBottomImageView.hidden = YES; break;
		case PlayerPositionLeft:   self.snapIndicatorLeftImageView.hidden   = YES; break;
		case PlayerPositionTop:    self.snapIndicatorTopImageView.hidden    = YES; break;
		case PlayerPositionRight:  self.snapIndicatorRightImageView.hidden  = YES; break;
	}
}

- (void)showSnapIndicatorForPlayer:(Player *)player
{
	switch (player.position)
	{
		case PlayerPositionBottom: self.snapIndicatorBottomImageView.hidden = NO; break;
		case PlayerPositionLeft:   self.snapIndicatorLeftImageView.hidden   = NO; break;
		case PlayerPositionTop:    self.snapIndicatorTopImageView.hidden    = NO; break;
		case PlayerPositionRight:  self.snapIndicatorRightImageView.hidden  = NO; break;
	}
}

- (void)showSplashView:(UIImageView *)splashView forPlayer:(Player *)player
{
	splashView.center = [self splashViewPositionForPlayer:player];
	splashView.hidden = NO;
	splashView.alpha = 1.0f;
	splashView.transform = CGAffineTransformMakeScale(2.0f, 2.0f);

	[UIView animateWithDuration:0.1f
		delay:0.0f
		options:UIViewAnimationOptionCurveEaseIn
		animations:^
		{
			splashView.transform = CGAffineTransformIdentity;
		}
		completion:^(BOOL finished)
		{
			[UIView animateWithDuration:0.1f 
				delay:1.0f
				options:UIViewAnimationOptionCurveEaseIn
				animations:^
				{
					splashView.alpha = 0.0f;
					splashView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
				}
				completion:^(BOOL finished)
				{
					splashView.hidden = YES;
				}];
		}];
}

- (CGPoint)splashViewPositionForPlayer:(Player *)player
{
	CGRect rect = self.view.bounds;
	CGFloat midX = CGRectGetMidX(rect);
	CGFloat midY = CGRectGetMidY(rect);
	CGFloat maxX = CGRectGetMaxX(rect);
	CGFloat maxY = CGRectGetMaxY(rect);

	if (player.position == PlayerPositionBottom)
		return CGPointMake(midX, maxY - CardHeight/2.0f - 30.0f);
	else if (player.position == PlayerPositionLeft)
		return CGPointMake(31.0f + CardWidth / 2.0f, midY - 22.0f);
	else if (player.position == PlayerPositionTop)
		return CGPointMake(midX, 29.0f + CardHeight/2.0f);
	else
		return CGPointMake(maxX - CardWidth + 1.0f, midY - 22.0f);
}

- (void)updateWinsLabels
{
	NSString *format = NSLocalizedString(@"%d Won", @"Number of games won");
	
	Player *player = [self.game playerAtPosition:PlayerPositionBottom];
	if (player != nil)
		self.playerWinsBottomLabel.text = [NSString stringWithFormat:format, player.gamesWon];

	player = [self.game playerAtPosition:PlayerPositionLeft];
	if (player != nil)
		self.playerWinsLeftLabel.text = [NSString stringWithFormat:format, player.gamesWon];

	player = [self.game playerAtPosition:PlayerPositionTop];
	if (player != nil)
		self.playerWinsTopLabel.text = [NSString stringWithFormat:format, player.gamesWon];

	player = [self.game playerAtPosition:PlayerPositionRight];
	if (player != nil)
		self.playerWinsRightLabel.text = [NSString stringWithFormat:format, player.gamesWon];
}

- (void)showTappedView
{
	Player *player = [self.game playerAtPosition:PlayerPositionBottom];
	Card *card = [player.closedCards topmostCard];
	if (card != nil)
	{
		CardView *cardView = [self cardViewForCard:card];

		if (_tappedView == nil)
		{
			_tappedView = [[UIImageView alloc] initWithFrame:cardView.bounds];
			_tappedView.backgroundColor = [UIColor clearColor];
			_tappedView.image = [UIImage imageNamed:@"Darken"];
			_tappedView.alpha = 0.6f;
			[self.view addSubview:_tappedView];
		}
		else
		{
			_tappedView.hidden = NO;
		}

		_tappedView.center = cardView.center;
		_tappedView.transform = cardView.transform;
	}
}

- (void)hideTappedView
{
	_tappedView.hidden = YES;
}

- (void)removeAllRemainingCardViews
{
	for (PlayerPosition p = PlayerPositionBottom; p <= PlayerPositionRight; ++p)
	{
		Player *player = [self.game playerAtPosition:p];
		if (player != nil)
		{
			[self removeRemainingCardsFromStack:player.openCards forPlayer:player];
			[self removeRemainingCardsFromStack:player.closedCards forPlayer:player];
		}
	}
}

- (void)removeRemainingCardsFromStack:(Stack *)stack forPlayer:(Player *)player
{
	NSTimeInterval delay = 0.0f;

	for (int t = 0; t < [stack cardCount]; ++t)
	{
		NSUInteger index = [stack cardCount] - t - 1;
		CardView *cardView = [self cardViewForCard:[stack cardAtIndex:index]];
		if (t < 5)
		{
			[cardView animateRemovalAtRoundEndForPlayer:player withDelay:delay];
			delay += 0.05f;
		}
		else  // we only animate the top 5 cards from the stack
		{
			[cardView removeFromSuperview];
		}
	}
}

#pragma mark - Actions

- (IBAction)exitAction:(id)sender
{
	if (self.game.isServer)
	{
		_alertView = [[UIAlertView alloc]
			initWithTitle:NSLocalizedString(@"End Game?", @"Alert title (user is host)")
			message:NSLocalizedString(@"This will terminate the game for all other players.", @"Alert message (user is host)")
			delegate:self
			cancelButtonTitle:NSLocalizedString(@"No", @"Button: No")
			otherButtonTitles:NSLocalizedString(@"Yes", @"Button: Yes"),
			nil];

		[_alertView show];
	}
	else
	{
		_alertView = [[UIAlertView alloc]
			initWithTitle: NSLocalizedString(@"Leave Game?", @"Alert title (user is not host)")
			message:nil
			delegate:self
			cancelButtonTitle:NSLocalizedString(@"No", @"Button: No")
			otherButtonTitles:NSLocalizedString(@"Yes", @"Button: Yes"),
			nil];

		[_alertView show];
	}
}

- (IBAction)turnOverPressed:(id)sender
{
	[self showTappedView];
}

- (IBAction)turnOverEnter:(id)sender
{
	[self showTappedView];
}

- (IBAction)turnOverExit:(id)sender
{
	[self hideTappedView];
}

- (IBAction)turnOverAction:(id)sender
{
	[self hideTappedView];
	[self.game turnCardForPlayerAtBottom];
}

- (IBAction)snapAction:(id)sender
{
	[self.game playerCalledSnap:[self.game playerAtPosition:PlayerPositionBottom]];
}

- (IBAction)nextRoundAction:(id)sender
{
	[self.game nextRound];
}

#pragma mark - GameDelegate

- (void)gameWaitingForClientsReady:(Game *)game
{
	self.centerLabel.text = NSLocalizedString(@"Waiting for other players...", @"Status text: waiting for clients");
}

- (void)gameWaitingForServerReady:(Game *)game
{
	self.centerLabel.text = NSLocalizedString(@"Waiting for game to start...", @"Status text: waiting for server");
}

- (void)gameDidBegin:(Game *)game
{
	[self showPlayerLabels];
	[self calculateLabelFrames];
	[self updateWinsLabels];
}

- (void)gameDidBeginNewRound:(Game *)game
{
	[self removeAllRemainingCardViews];
}

- (void)gameShouldDealCards:(Game *)game startingWithPlayer:(Player *)startingPlayer
{
	self.centerLabel.text = NSLocalizedString(@"Dealing...", @"Status text: dealing");

	self.snapButton.hidden = YES;
	self.nextRoundButton.hidden = YES;

	NSTimeInterval delay = 1.0f;

	_dealingCardsSound.currentTime = 0.0f;
	[_dealingCardsSound prepareToPlay];
	[_dealingCardsSound performSelector:@selector(play) withObject:nil afterDelay:delay];

	for (int t = 0; t < 26; ++t)
	{
		for (PlayerPosition p = startingPlayer.position; p < startingPlayer.position + 4; ++p)
		{
			Player *player = [self.game playerAtPosition:p % 4];
			if (player != nil && t < [player.closedCards cardCount])
			{
				CardView *cardView = [[CardView alloc] initWithFrame:CGRectMake(0, 0, CardWidth, CardHeight)];
				cardView.card = [player.closedCards cardAtIndex:t];
				[self.cardContainerView addSubview:cardView];
				[cardView animateDealingToPlayer:player withDelay:delay];
				delay += 0.1f;
			}
		}
	}

	[self performSelector:@selector(afterDealing) withObject:nil afterDelay:delay];	
}

- (void)afterDealing
{
	[_dealingCardsSound stop];
	self.snapButton.hidden = NO;
	[self.game beginRound];
}

- (void)game:(Game *)game didActivatePlayer:(Player *)player
{
	[self showIndicatorForActivePlayer];
	self.snapButton.enabled = YES;
}

- (void)game:(Game *)game player:(Player *)player turnedOverCard:(Card *)card
{
	self.snapButton.enabled = (player.position != PlayerPositionBottom);

	[_turnCardSound play];

	CardView *cardView = [self cardViewForCard:card];
	[cardView animateTurningOverForPlayer:player];
}

- (void)game:(Game *)game didRecycleCards:(NSArray *)recycledCards forPlayer:(Player *)player
{
	self.snapButton.enabled = NO;
	self.turnOverButton.enabled = NO;

	NSTimeInterval delay = 0.0f;
	for (Card *card in recycledCards)
	{
		CardView *cardView = [self cardViewForCard:card];
		[cardView animateRecycleForPlayer:player withDelay:delay];
		delay += 0.025f;
	}

	[self performSelector:@selector(afterRecyclingCardsForPlayer:) withObject:player afterDelay:delay + 0.5f];
}

- (void)afterRecyclingCardsForPlayer:(Player *)player
{
	self.snapButton.enabled = YES;
	self.turnOverButton.enabled = YES;

	[self.game resumeAfterRecyclingCardsForPlayer:player];
}

- (void)game:(Game *)game playerCalledSnapWithNoMatch:(Player *)player
{
	[_wrongMatchSound play];

	[self showSplashView:self.wrongSnapImageView forPlayer:player];
	[self showSnapIndicatorForPlayer:player];
	[self performSelector:@selector(hideSnapIndicatorForPlayer:) withObject:player afterDelay:1.0f];

	self.turnOverButton.enabled = NO;
	self.centerLabel.text = NSLocalizedString(@"No Match!", @"Status text: player called snap with no match");

	[self performSelector:@selector(playerMustPayCards:) withObject:player afterDelay:1.0f];
}

- (void)playerMustPayCards:(Player *)player
{
	self.centerLabel.text = [NSString stringWithFormat: NSLocalizedString(@"%@ Must Pay", @"Status text: player must pay cards to the others"), player.name];
	[self.game playerMustPayCards:player];
	[self performSelector:@selector(afterMovingCardsForPlayer:) withObject:player afterDelay:1.0f];
}

- (void)afterMovingCardsForPlayer:(Player *)player
{
	BOOL changedPlayer = [self.game resumeAfterMovingCardsForPlayer:player];

	self.snapButton.enabled = YES;
	self.turnOverButton.enabled = YES;

	// If he has no more cards available, the local player no longer participates.
	if ([[self.game playerAtPosition:PlayerPositionBottom] totalCardCount] == 0)
		self.snapButton.hidden = YES;

	// Show the "Player X's Turn" message again for the currently active player.
	if (!changedPlayer)
		[self showIndicatorForActivePlayer];
}

- (void)game:(Game *)game playerCalledSnapTooLate:(Player *)player
{
	[self showSnapIndicatorForPlayer:player];
	[self performSelector:@selector(hideSnapIndicatorForPlayer:) withObject:player afterDelay:1.0f];
}

- (void)game:(Game *)game player:(Player *)player calledSnapWithMatchingPlayers:(NSSet *)matchingPlayers
{
	[_correctMatchSound play];

	[self showSplashView:self.correctSnapImageView forPlayer:player];
	[self showSnapIndicatorForPlayer:player];
	[self performSelector:@selector(hideSnapIndicatorForPlayer:) withObject:player afterDelay:1.0f];

	self.turnOverButton.enabled = NO;
	self.centerLabel.text = NSLocalizedString(@"*** Match! ***", @"Status text: player called snap with a match");

	NSArray *array = [NSArray arrayWithObjects:player, matchingPlayers, nil];
	[self performSelector:@selector(playerWillReceiveCards:) withObject:array afterDelay:1.0f];
}

- (void)playerWillReceiveCards:(NSArray *)array
{
	Player *player = [array objectAtIndex:0];
	NSSet *matchingPlayers = [array objectAtIndex:1];

	if (player.position == PlayerPositionBottom)
		self.centerLabel.text = NSLocalizedString(@"You Receive Cards", @"Status text: player will receive cards from the others");
	else
		self.centerLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ Receives Cards", @"Status text: player will receive cards from the others"), player.name];

	// Note that we have to loop through the players in the same order on
	// both the server and the clients, otherwise the cards get mixed up.
	for (PlayerPosition p = player.position; p < player.position + 4; ++p)
	{
		Player *otherPlayer = [self.game playerAtPosition:p % 4];
		if (otherPlayer != nil && [matchingPlayers containsObject:otherPlayer])
		{
			NSArray *cards = [otherPlayer giveAllOpenCardsToPlayer:player];
			for (Card *card in cards)
			{
				CardView *cardView = [self cardViewForCard:card];
				[cardView animateCloseAndMoveFromPlayer:otherPlayer toPlayer:player withDelay:0.0f];
			}
		}
	}

	[self performSelector:@selector(afterMovingCardsForPlayer:) withObject:player afterDelay:1.0f];
}

- (void)game:(Game *)game player:(Player *)fromPlayer paysCard:(Card *)card toPlayer:(Player *)toPlayer
{
	CardView *cardView = [self cardViewForCard:card];
	[cardView animatePayCardFromPlayer:fromPlayer toPlayer:toPlayer];
}

- (void)game:(Game *)game roundDidEndWithWinner:(Player *)player
{
	self.centerLabel.text = [NSString stringWithFormat:NSLocalizedString(@"** Winner: %@ **", @"Status text: winner of a round"), player.name];

	self.snapButton.hidden = YES;
	self.nextRoundButton.hidden = !game.isServer;

	[self updateWinsLabels];
	[self hideActivePlayerIndicator];
}

- (void)game:(Game *)game playerDidDisconnect:(Player *)disconnectedPlayer redistributedCards:(NSDictionary *)redistributedCards
{
	[self hidePlayerLabelsForPlayer:disconnectedPlayer];
	[self hideActiveIndicatorForPlayer:disconnectedPlayer];
	[self hideSnapIndicatorForPlayer:disconnectedPlayer];

	for (PlayerPosition p = PlayerPositionBottom; p <= PlayerPositionRight; ++p)
	{
		Player *otherPlayer = [self.game playerAtPosition:p];
		if (otherPlayer != disconnectedPlayer)
		{
			NSArray *cards = [redistributedCards objectForKey:otherPlayer.peerID];
			for (Card *card in cards)
			{
				// Note: the CardView at this point has a Card object that has
				// the same suit and value as our "card", but on the client it
				// is actually a different Card object!
				CardView *cardView = [self cardViewForCard:card];
				cardView.card = card;
				[cardView animateCloseAndMoveFromPlayer:disconnectedPlayer toPlayer:otherPlayer withDelay:0.0f];			
			}
		}
	}
}

- (void)game:(Game *)game didQuitWithReason:(QuitReason)reason
{
	[self.delegate gameViewController:self didQuitWithReason:reason];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != alertView.cancelButtonIndex)
	{
		// Stop any pending performSelector:withObject:afterDelay: messages.
		[NSObject cancelPreviousPerformRequestsWithTarget:self];

		[self.game quitGameWithReason:QuitReasonUserQuit];
	}
}

@end
