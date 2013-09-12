//
//  GameController.m
//  Sample 03
//
//  Created by Lucas Jordan on 4/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameController.h"
#import "Score.h"

@implementation GameController

-(void)setPreviousGame:(CoinsGame*)aCoinsGame{
    previousGame = [aCoinsGame retain];
    
    if (previousGame != nil && [previousGame remaingTurns] > 0){
        [continueButton setHidden:NO];
    } else {
        [continueButton setHidden:YES];
    }
}

-(CoinsGame*)currentGame{
    return [coinsController coinsGame];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:loadingView];
    
    //NSOperationQueue *queue = [NSOperationQueue new];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadImages) object:nil];
    [queue addOperation:operation];
    [operation release];
    
}

-(void)loadImages{
    //sleeping so we can see the loading view. In a production app, don't sleep :)
    [NSThread sleepForTimeInterval:1.0];
    
    [coinsController loadImages];
    [loadingView removeFromSuperview];
    [self.view addSubview:welcomeView];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [landscapePlayView release];
    [landscapeGameHolderView release];
    [portraitPlayView release];
    [portraitGameHolderView release];
    [loadingView release];
    [welcomeView release];
    [continueButton release];
    [aboutView release];
    [coinsController release];
    [remainingTurnsLabels release];
    [scoreLabels release];
    [highscoreController release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
    [landscapePlayView release];
    landscapePlayView = nil;
    [landscapeGameHolderView release];
    landscapeGameHolderView = nil;
    [portraitPlayView release];
    portraitPlayView = nil;
    [portraitGameHolderView release];
    portraitGameHolderView = nil;
    [loadingView release];
    loadingView = nil;
    [welcomeView release];
    welcomeView = nil;
    [continueButton release];
    continueButton = nil;
    [aboutView release];
    aboutView = nil;
    [coinsController release];
    coinsController = nil;
    [remainingTurnsLabels release];
    remainingTurnsLabels = nil;
    [scoreLabels release];
    scoreLabels = nil;
    [highscoreController release];
    highscoreController = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (isPlayingGame){
        [self showPlayView:interfaceOrientation];
        return YES;
    } else {
        return interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown;
    }
}
-(void)showPlayView: (UIInterfaceOrientation)interfaceOrientation{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        
        [portraitPlayView removeFromSuperview];
        [self.view addSubview: landscapePlayView];
        
        [landscapeGameHolderView addSubview: coinsController.view];
    } else {
        
        [landscapePlayView removeFromSuperview];
        [self.view addSubview: portraitPlayView];
        
        [portraitGameHolderView addSubview: coinsController.view];
    }
}

- (IBAction)continueGameClicked:(id)sender {
    [UIView beginAnimations:nil context:@"flipTransitionToBack"];
    [UIView setAnimationDuration:1.2];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    
    [welcomeView removeFromSuperview];
    
    UIInterfaceOrientation interfaceOrientation = [self interfaceOrientation];
    [self showPlayView:interfaceOrientation];
    
    [coinsController continueGame:previousGame];
    
    [UIView commitAnimations];
    isPlayingGame = YES;
}

- (IBAction)newGameClicked:(id)sender {
    [UIView beginAnimations:nil context:@"flipTransitionToBack"];
    [UIView setAnimationDuration:1.2];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];

    [welcomeView removeFromSuperview];
    
    UIInterfaceOrientation interfaceOrientation = [self interfaceOrientation];
    [self showPlayView:interfaceOrientation];
    
    [coinsController newGame];
    
    [UIView commitAnimations];
    isPlayingGame = YES;
}
-(void)alignInterfaceWithDeviceOrientation{
    
}
- (IBAction)highScoresClicked:(id)sender {
    
    //Make high score view 100% clear and add it on top of the welcome view.
    [highscoreController.view setAlpha:0.0];
    [self.view addSubview:highscoreController.view];
    
    //setup animation
    [UIView beginAnimations:nil context:@"fadeInHighScoreView"];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        
    //make changes
    [welcomeView setAlpha:0.0];
    [highscoreController.view setAlpha:1.0];
    
    [UIView commitAnimations];
}
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    if ([@"fadeInHighScoreView" isEqual:context]){
        [welcomeView removeFromSuperview];
        [welcomeView setAlpha:1.0];
    }
}

- (IBAction)aboutClicked:(id)sender {
    [UIView beginAnimations:nil context:@"flipTransitionToBack"];
    [UIView setAnimationDuration:1.2];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    
    [welcomeView removeFromSuperview];
    [self.view addSubview: aboutView];
    
    
    [UIView commitAnimations];
}

- (IBAction)aboutDoneClicked:(id)sender {
    [UIView beginAnimations:nil context:@"flipTransitionToBack"];
    [UIView setAnimationDuration:1.2];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    
    [aboutView removeFromSuperview];
    [self.view addSubview: welcomeView];
    
    
    [UIView commitAnimations];
}

- (IBAction)highscoreDoneClicked:(id)sender {
    [UIView beginAnimations:@"AnimationId" context:@"flipTransitionToBack"];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    
    [highscoreController.view removeFromSuperview];
    [self.view addSubview: welcomeView];
    
    
    [UIView commitAnimations];
}

//CoinsControllerDelegate tasks
-(void)gameDidStart:(CoinsController*)aCoinsController with:(CoinsGame*)game{
    for (UILabel* label in scoreLabels){
        [label setText:[NSString stringWithFormat:@"%d", [game score]]];
    }
    for (UILabel* label in remainingTurnsLabels){
        [label setText:[NSString stringWithFormat:@"%d", [game remaingTurns]]];
    }
}
-(void)scoreIncreases:(CoinsController*)aCoinsController with:(int)newScore{
    
    
    
    for (UILabel* label in scoreLabels){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.75];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:label cache:YES];
        
        [label setText:[NSString stringWithFormat:@"%d", newScore]];
        
        [UIView commitAnimations];
    }
    
}
-(void)turnsRemainingDecreased:(CoinsController*)aCoinsController with:(int)turnsRemaining{
    for (UILabel* label in remainingTurnsLabels){
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.75];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:label cache:YES];
        
        [label setText:[NSString stringWithFormat:@"%d", turnsRemaining]];
        
        [UIView commitAnimations];
    }
}
-(void)gameOver:(CoinsController*)aCoinsController with:(CoinsGame*)game{
    [continueButton setHidden:YES];
    
    Score* score = [Score score:[game score] At:[NSDate date]];
    
    [highscoreController addScore:score];
  
    isPlayingGame = NO;
    
    UIWindow* window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    window.rootViewController = nil;
    window.rootViewController = self;
    
    [UIView beginAnimations:nil context:@"flipTransitionToBack"];
    [UIView setAnimationDuration:1.2];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    
    [coinsController.view removeFromSuperview];
    [self.view addSubview:highscoreController.view];
    
    
    [UIView commitAnimations];
}
@end
