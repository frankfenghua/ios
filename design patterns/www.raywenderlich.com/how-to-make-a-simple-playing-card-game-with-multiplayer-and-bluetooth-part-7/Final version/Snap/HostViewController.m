
#import "HostViewController.h"
#import "UIButton+SnapAdditions.h"
#import "UIFont+SnapAdditions.h"
#import "PeerCell.h"

@interface HostViewController ()
@property (nonatomic, weak) IBOutlet UILabel *headingLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *startButton;
@end

@implementation HostViewController
{
	MatchmakingServer *_matchmakingServer;
	QuitReason _quitReason;
}

@synthesize delegate = _delegate;

@synthesize headingLabel = _headingLabel;
@synthesize nameLabel = _nameLabel;
@synthesize nameTextField = _nameTextField;
@synthesize statusLabel = _statusLabel;
@synthesize tableView = _tableView;
@synthesize startButton = _startButton;

- (void)dealloc
{
	#ifdef DEBUG
	NSLog(@"dealloc %@", self);
	#endif
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.headingLabel.font = [UIFont rw_snapFontWithSize:24.0f];;
	self.nameLabel.font = [UIFont rw_snapFontWithSize:16.0f];
	self.statusLabel.font = [UIFont rw_snapFontWithSize:16.0f];
	self.nameTextField.font = [UIFont rw_snapFontWithSize:20.0f];

	[self.startButton rw_applySnapStyle];

	UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.nameTextField action:@selector(resignFirstResponder)];
	gestureRecognizer.cancelsTouchesInView = NO;
	[self.view addGestureRecognizer:gestureRecognizer];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	if (_matchmakingServer == nil)
	{
		_matchmakingServer = [[MatchmakingServer alloc] init];
		_matchmakingServer.delegate = self;
		_matchmakingServer.maxClients = 3;
		[_matchmakingServer startAcceptingConnectionsForSessionID:SESSION_ID];

		self.nameTextField.placeholder = _matchmakingServer.session.displayName;
		[self.tableView reloadData];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)startAction:(id)sender
{
	if (_matchmakingServer != nil && [_matchmakingServer connectedClientCount] > 0)
	{
		NSString *name = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		if ([name length] == 0)
			name = _matchmakingServer.session.displayName;

		[_matchmakingServer stopAcceptingConnections];

		[self.delegate hostViewController:self startGameWithSession:_matchmakingServer.session playerName:name clients:_matchmakingServer.connectedClients];
	}
}

- (IBAction)exitAction:(id)sender
{
	_quitReason = QuitReasonUserQuit;
	[_matchmakingServer endSession];
	[self.delegate hostViewControllerDidCancel:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (_matchmakingServer != nil)
		return [_matchmakingServer connectedClientCount];
	else
		return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"CellIdentifier";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
		cell = [[PeerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

	NSString *peerID = [_matchmakingServer peerIDForConnectedClientAtIndex:indexPath.row];
	cell.textLabel.text = [_matchmakingServer displayNameForPeerID:peerID];

	return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return NO;
}

#pragma mark - MatchmakingServerDelegate

- (void)matchmakingServer:(MatchmakingServer *)server clientDidConnect:(NSString *)peerID
{
	[self.tableView reloadData];
}

- (void)matchmakingServer:(MatchmakingServer *)server clientDidDisconnect:(NSString *)peerID
{
	[self.tableView reloadData];
}

- (void)matchmakingServerSessionDidEnd:(MatchmakingServer *)server
{
	_matchmakingServer.delegate = nil;
	_matchmakingServer = nil;
	[self.tableView reloadData];
	[self.delegate hostViewController:self didEndSessionWithReason:_quitReason];
}

- (void)matchmakingServerNoNetwork:(MatchmakingServer *)session
{
	_quitReason = QuitReasonNoNetwork;
}

@end
