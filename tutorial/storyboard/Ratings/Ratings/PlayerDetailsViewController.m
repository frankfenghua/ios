//
//  PlayerDetailsViewController.m
//  Ratings
//
//  Created by Marin Todorov on 9/9/13.
//
//

#import "PlayerDetailsViewController.h"

@interface PlayerDetailsViewController ()

@end

@implementation PlayerDetailsViewController
{
    	NSString *game;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		NSLog(@"init PlayerDetailsViewController");
		game = @"Chess";
	}
	return self;
}

- (IBAction)cancel:(id)sender
{
	[self.delegate playerDetailsViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender
{
	Player *player = [[Player alloc] init];
	player.name = self.nameTextField.text;
	player.game = game;
	player.rating = 1;
	[self.delegate playerDetailsViewController:self
                                  didAddPlayer:player];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.detailLabel.text = game;
}

#pragma mark - GamePickerViewControllerDelegate

- (void)gamePickerViewController:
(GamePickerViewController *)controller
                   didSelectGame:(NSString *)theGame
{
	game = theGame;
	self.detailLabel.text = game;
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0)
		[self.nameTextField becomeFirstResponder];
}

- (void)dealloc
{
	NSLog(@"dealloc PlayerDetailsViewController");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"PickGame"])
	{
		GamePickerViewController *gamePickerViewController =
        segue.destinationViewController;
		gamePickerViewController.delegate = self;
		gamePickerViewController.game = game;
	}
}

@end
