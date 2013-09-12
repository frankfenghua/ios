//
//  GameController.h
//  Sample 03
//
//  Created by Lucas Jordan on 4/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoinsController.h"
#import "CoinsGame.h"
#import "HighscoreController.h"

@interface GameController : UIViewController <CoinsControllerDelegate>{
    
    IBOutlet UIView *landscapePlayView;
    IBOutlet UIView *landscapeGameHolderView;
    IBOutlet UIView *portraitPlayView;
    IBOutlet UIView *portraitGameHolderView;
    IBOutlet UIView *loadingView;
    IBOutlet UIView *welcomeView;
    IBOutlet UIButton *continueButton;
    IBOutlet UIView *aboutView;

    IBOutlet CoinsController *coinsController;
    IBOutletCollection(UILabel) NSArray *remainingTurnsLabels;
    IBOutletCollection(UILabel) NSArray *scoreLabels;
    IBOutlet HighscoreController *highscoreController;
    
    CoinsGame* previousGame;
    BOOL isPlayingGame;
}
-(void)setPreviousGame:(CoinsGame*)aCoinsGame;
-(CoinsGame*)currentGame;

- (IBAction)continueGameClicked:(id)sender;
- (IBAction)newGameClicked:(id)sender;
- (IBAction)highScoresClicked:(id)sender;
- (IBAction)aboutClicked:(id)sender;
- (IBAction)aboutDoneClicked:(id)sender;
- (IBAction)highscoreDoneClicked:(id)sender;

-(void)loadImages;
-(void)showPlayView: (UIInterfaceOrientation)interfaceOrientation;

@end
