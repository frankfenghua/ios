//
//  BIDMainViewController.m
//  AppSettings
//

#import "BIDMainViewController.h"

@interface BIDMainViewController ()

@end

@implementation BIDMainViewController

- (void)refreshFields {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.usernameLabel.text = [defaults objectForKey:kUsernameKey];
    self.passwordLabel.text = [defaults objectForKey:kPasswordKey];
    self.protocolLabel.text = [defaults objectForKey:kProtocolKey];
    self.warpDriveLabel.text = [defaults boolForKey:kWarpDriveKey]
                                ? @"Engaged" : @"Disabled";
    self.warpFactorLabel.text = [[defaults objectForKey:kWarpFactorKey]
                            stringValue];
    self.favoriteTeaLabel.text = [defaults objectForKey:kFavoriteTeaKey];
    self.favoriteCandyLabel.text = [defaults objectForKey:kFavoriteCandyKey];
    self.favoriteGameLabel.text = [defaults objectForKey:kFavoriteGameKey];
    self.favoriteExcuseLabel.text = [defaults objectForKey:kFavoriteExcuseKey];
    self.favoriteSinLabel.text = [defaults objectForKey:kFavoriteSinKey];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshFields];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(BIDFlipsideViewController *)controller
{
    [self refreshFields];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

@end
