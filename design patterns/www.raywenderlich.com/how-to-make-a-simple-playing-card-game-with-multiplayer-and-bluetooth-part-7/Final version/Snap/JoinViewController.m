
#import "JoinViewController.h"
#import "PeerCell.h"
#import "UIFont+SnapAdditions.h"

@interface JoinViewController ()
@property (nonatomic, weak) IBOutlet UILabel *headingLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet UIView *waitView;
@property (nonatomic, weak) IBOutlet UILabel *waitLabel;
@end

@implementation JoinViewController
{
	MatchmakingClient *_matchmakingClient;
	QuitReason _quitReason;
}

@synthesize delegate = _delegate;

@synthesize headingLabel = _headingLabel;
@synthesize nameLabel = _nameLabel;
@synthesize nameTextField = _nameTextField;
@synthesize statusLabel = _statusLabel;
@synthesize tableView = _tableView;

@synthesize waitView = _waitView;
@synthesize waitLabel = _waitLabel;

- (void)dealloc
{
	#ifdef DEBUG
	NSLog(@"dealloc %@", self);
	#endif
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.headingLabel.font = [UIFont rw_snapFontWithSize:24.0f];
	self.nameLabel.font = [UIFont rw_snapFontWithSize:16.0f];
	self.statusLabel.font = [UIFont rw_snapFontWithSize:16.0f];
	self.waitLabel.font = [UIFont rw_snapFontWithSize:18.0f];
	self.nameTextField.font = [UIFont rw_snapFontWithSize:20.0f];

	UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.nameTextField action:@selector(resignFirstResponder)];
	gestureRecognizer.cancelsTouchesInView = NO;
	[self.view addGestureRecognizer:gestureRecognizer];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	self.waitView = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	if (_matchmakingClient == nil)
	{
		_quitReason = QuitReasonConnectionDropped;

		_matchmakingClient = [[MatchmakingClient alloc] init];
		_matchmakingClient.delegate = self;
		[_matchmakingClient startSearchingForServersWithSessionID:SESSION_ID];

		self.nameTextField.placeholder = _matchmakingClient.session.displayName;
		[self.tableView reloadData];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)exitAction:(id)sender
{
	_quitReason = QuitReasonUserQuit;
	[_matchmakingClient disconnectFromServer];
	[self.delegate joinViewControllerDidCancel:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (_matchmakingClient != nil)
		return [_matchmakingClient availableServerCount];
	else
		return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"CellIdentifier";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
		cell = [[PeerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

	NSString *peerID = [_matchmakingClient peerIDForAvailableServerAtIndex:indexPath.row];
	cell.textLabel.text = [_matchmakingClient displayNameForPeerID:peerID];

	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	if (_matchmakingClient != nil)
	{
		[self.view addSubview:self.waitView];

		NSString *peerID = [_matchmakingClient peerIDForAvailableServerAtIndex:indexPath.row];
		[_matchmakingClient connectToServerWithPeerID:peerID];
	}
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return NO;
}

#pragma mark - MatchmakingClientDelegate

- (void)matchmakingClient:(MatchmakingClient *)client serverBecameAvailable:(NSString *)peerID
{
	[self.tableView reloadData];
}

- (void)matchmakingClient:(MatchmakingClient *)client serverBecameUnavailable:(NSString *)peerID
{
	[self.tableView reloadData];
}

- (void)matchmakingClient:(MatchmakingClient *)client didConnectToServer:(NSString *)peerID
{
	NSString *name = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ([name length] == 0)
		name = _matchmakingClient.session.displayName;

	[self.delegate joinViewController:self startGameWithSession:_matchmakingClient.session playerName:name server:peerID];
}

- (void)matchmakingClient:(MatchmakingClient *)client didDisconnectFromServer:(NSString *)peerID
{
	_matchmakingClient.delegate = nil;
	_matchmakingClient = nil;
	[self.tableView reloadData];
	[self.delegate joinViewController:self didDisconnectWithReason:_quitReason];
}

- (void)matchmakingClientNoNetwork:(MatchmakingClient *)client
{
	_quitReason = QuitReasonNoNetwork;
}

@end
