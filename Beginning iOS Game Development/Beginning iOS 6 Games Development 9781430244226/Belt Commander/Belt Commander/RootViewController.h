//
//  RootViewController.h
//  Belt Commander
//
//  Created by Lucas Jordan on 8/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#define FB_APP_ID @"156916307724712"

#import <UIKit/UIKit.h>
#import "BeltCommanderController.h"
#import <GameKit/GameKit.h>
#import <Accounts/Accounts.h>
#import <StoreKit/StoreKit.h>
#import "ExtrasController.h"

@interface RootViewController : UINavigationController<BeltCommanderDelegate, UIAlertViewDelegate, GKLeaderboardViewControllerDelegate>{
    IBOutlet UIViewController* welcomeController;
    IBOutlet BeltCommanderController* beltCommanderController;
    IBOutlet ExtrasController *extrasController;
    IBOutlet UIButton *leaderBoardButton;
    
    IBOutlet UIButton *tweetButton;
    IBOutlet UIButton *facebookButton;
    
    UIAlertView* newGameAlertView;
    UIAlertView* pauseGameAlerTView;
    
    GKLocalPlayer* localPlayer;
    
    ACAccountStore* accountStore;
    ACAccount* facebookAccount;
    
    BOOL isPlaying;
}
-(void)doPause;
-(void)endOfGameCleanup;

-(void)initGameCenter;
-(void)initFacebook;
-(void)initTwitter;

-(void)notifyGameCenter;
-(void)notifyFacebook;

-(BOOL)handleOpenURL:(NSURL *)url;

-(void)applicationWillResignActive;
-(void)applicationDidBecomeActive;
@end
