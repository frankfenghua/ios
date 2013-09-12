//
//  RootViewController.m
//  Belt Commander
//
//  Created by Lucas Jordan on 8/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import <Social/Social.h>


@implementation RootViewController


-(void)gameStarted:(BeltCommanderController*)aBeltCommanderController{
    isPlaying = YES;
}
-(void)gameOver:(BeltCommanderController*)aBeltCommanderController{
    if (newGameAlertView == nil){
        newGameAlertView = [[UIAlertView alloc] initWithTitle:@"Your Game Is Over." message:@"Play Again?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    }
    [newGameAlertView show];
      
    [self endOfGameCleanup];
}
-(void)endOfGameCleanup{
    isPlaying = NO;
    [self notifyGameCenter];
    [self notifyFacebook];
}

-(void)notifyGameCenter{
    if ([localPlayer isAuthenticated]){
        GKScore* score = [[GKScore alloc] initWithCategory:@"beltcommander.highscores"];
        score.value = [beltCommanderController score];
        
        [score reportScoreWithCompletionHandler:^(NSError *error){
            if (error){
                //handle error
            }
        }];
    }
}
-(void)notifyFacebook{
    if (facebookAccount){
    
        NSString* desc = [NSString stringWithFormat:@"I just scored %ld points on Belt Commander.", [beltCommanderController score]];
        
        NSDictionary* params = @{
        @"link": @"http://itunes.apple.com/us/app/belt-commander/id460769032",
        @"caption": @"Presented by ClayWare Games, LLC",
        @"description": desc,
        @"message": @"A new high score!"
        };
        
        NSURL* feedURL = [NSURL URLWithString:@"https://graph.facebook.com/me/feed"];
        
        SLRequest* request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodPOST URL:feedURL parameters:params];
        
        request.account = facebookAccount;
        
        [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            if (error){
                NSLog(@"%@", error);
            } else {
                //Success
            }
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == pauseGameAlerTView){
        if (buttonIndex == 0) {
            [self endOfGameCleanup];
            [self popViewControllerAnimated:YES];
        } else {
            [beltCommanderController setIsPaused:NO];
        }
    }
    if (alertView == newGameAlertView){
        if (buttonIndex == 0) {
            [beltCommanderController doNewGame: [extrasController gameParams]];
        } else {
            [self popViewControllerAnimated:YES];
        }
    }
}
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initGameCenter];
    [self initFacebook];
    [self initTwitter];
}

-(void)initGameCenter{
    Class gkClass = NSClassFromString(@"GKLocalPlayer");
    
    BOOL iosSupported = [[[UIDevice currentDevice] systemVersion] compare:@"4.1" options:NSNumericSearch] != NSOrderedAscending;
    
    if (gkClass && iosSupported){
        
        localPlayer = [GKLocalPlayer localPlayer];
        [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
            if (localPlayer.authenticated){
                [leaderBoardButton setEnabled:YES];
            } else {
                [leaderBoardButton setEnabled:NO];
            }
        }];
    }
}


-(void)initTwitter{
    [tweetButton setEnabled:[SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]];
}

- (IBAction)playButtonClicked:(id)sender {
    [self pushViewController:beltCommanderController animated:YES];
    [beltCommanderController doNewGame: [extrasController gameParams]];
}

-(void)initFacebook{
    [facebookButton setEnabled: [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]];
}

- (IBAction)facebookButtonClicked:(id)sender {
    accountStore = [[ACAccountStore alloc] init];
    ACAccountType* facebookAccountType = [accountStore accountTypeWithAccountTypeIdentifier: ACAccountTypeIdentifierFacebook];
    
    NSDictionary *dict = @{
        ACFacebookAppIdKey: FB_APP_ID,
        ACFacebookPermissionsKey: @[@"publish_stream"],
        ACFacebookAudienceKey: ACFacebookAudienceFriends
    };
    
    [accountStore requestAccessToAccountsWithType:facebookAccountType options:dict completion:^(BOOL granted, NSError *error) {
        
        if (granted){
            
            NSArray* accounts = [accountStore accountsWithAccountType:facebookAccountType];
            facebookAccount = [accounts lastObject];
            
        } else {
            NSLog(@"Could not get permission to access FB: %@", error);
        }
        
    }];
}

- (IBAction)leaderBoardClicked:(id)sender {
        GKLeaderboardViewController* leaderBoardController = [[GKLeaderboardViewController alloc] init];
        leaderBoardController.category = @"beltcommander.highscores";
        leaderBoardController.leaderboardDelegate = self;
        [self presentModalViewController:leaderBoardController animated:YES];
}
- (IBAction)tweetButtonClicked:(id)sender {
    SLComposeViewController* twitterSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [twitterSheet setInitialText:@"Check out this iOS game, Belt Commander!"];
    [twitterSheet addURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/belt-commander/id460769032?ls=1&mt=8"]];
    [self presentViewController:twitterSheet animated:YES completion:^(void){
        NSLog(@"twitter done");
    }];
}
- (IBAction)extrasButtonClicked:(id)sender {
    [self pushViewController:extrasController animated:YES];
}
- (IBAction)backFromExtras:(id)sender {
    [self popViewControllerAnimated:YES];
}
- (IBAction)pauseButtonClicked:(id)sender {
    [self doPause];
}
-(void)doPause{
    if (isPlaying){
        [beltCommanderController setIsPaused:YES];
        if (pauseGameAlerTView == nil){
            pauseGameAlerTView = [[UIAlertView alloc] initWithTitle:@"Paused." message:@"Exit Game?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        }
        
        [pauseGameAlerTView show];
    }
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(void)applicationWillResignActive{
    [beltCommanderController applicationWillResignActive];
}
-(void)applicationDidBecomeActive{
    [beltCommanderController applicationDidBecomeActive];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft | interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
