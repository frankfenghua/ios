//
//  RockPaperScissorsController.m
//  Sample 02
//
//  Created by Lucas Jordan on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RockPaperScissorsController.h"


@implementation RockPaperScissorsController

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
/*
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}
*/

-(void)setup:(CGSize)size{
	
    if (!isSetup){
        isSetup = true;
        
        srand(time(NULL));
        
        buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [buttonView setBackgroundColor:[UIColor lightGrayColor]];
        [self.view addSubview:buttonView];
        
        float sixtyPercent = size.width * .6;
        float twentyPercent = size.width * .2;
        float twentFivePercent = size.height/4;
        float thirtyThreePercent = size.height/3;
        
        rockButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [rockButton setFrame:CGRectMake(twentyPercent, twentFivePercent, sixtyPercent, 40)];
        [rockButton setTitle:@"Rock" forState:UIControlStateNormal];
        [rockButton addTarget:self action:@selector(userSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        paperButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [paperButton setFrame:CGRectMake(twentyPercent, twentFivePercent*2, sixtyPercent, 40)];
        [paperButton setTitle:@"Paper" forState:UIControlStateNormal];
        [paperButton addTarget:self action:@selector(userSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        scissersButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [scissersButton setFrame:CGRectMake(twentyPercent, twentFivePercent*3, sixtyPercent, 40)];
        [scissersButton setTitle:@"Scissors" forState:UIControlStateNormal];
        [scissersButton addTarget:self action:@selector(userSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [buttonView addSubview:rockButton];
        [buttonView addSubview:paperButton];
        [buttonView addSubview:scissersButton];
        
        
        resultView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [resultView setBackgroundColor:[UIColor lightGrayColor]];
        
        resultLabel = [[UILabel new] initWithFrame:CGRectMake(twentyPercent, thirtyThreePercent, sixtyPercent, 40)];
        [resultLabel setAdjustsFontSizeToFitWidth:YES];
        [resultView addSubview:resultLabel];
        
        continueButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [continueButton setFrame:CGRectMake(twentyPercent, thirtyThreePercent*2, sixtyPercent, 40)];
        [continueButton setTitle:@"Continue" forState:UIControlStateNormal];
        [continueButton addTarget:self action:@selector(continueGame:) forControlEvents:UIControlEventTouchUpInside];
        [resultView addSubview:continueButton];
        
    }
}

-(void)userSelected:(id)sender{
	int result = random()%3;
	
	UIButton* selectedButton = (UIButton*)sender;
	NSString* selection = [[selectedButton titleLabel] text];
	
	NSString* resultText;
	if (result == 0){//lost
		NSString* computerSelection = [self getLostTo:selection];
		resultText = [@"Lost, iOS selected " stringByAppendingString: computerSelection];
	} else if (result == 1) {//tie
		resultText = [@"Tie, iOS selected " stringByAppendingString: selection];
	} else {//win
		NSString* computerSelection = [self getWonTo:selection];
		resultText = [@"Won, iOS selected " stringByAppendingString: computerSelection];
	}
	
	[resultLabel setText:resultText];
	
	[buttonView removeFromSuperview];
	[self.view addSubview:resultView];
    
}
-(void)continueGame:(id)sender{
	
	[resultView removeFromSuperview];
	[self.view addSubview:buttonView];
}

-(NSString*)getLostTo:(NSString*)selection{
	if ([selection isEqual:@"Rock"]){
		return @"Paper";
	} else if ([selection isEqual:@"Paper"]){
		return @"Scissors";
	} else {
		return @"Rock";
	}
}
-(NSString*)getWonTo:(NSString*)selection{
	if ([selection isEqual:@"Rock"]){
		return @"Scissors";
	} else if ([selection isEqual:@"Paper"]){
		return @"Rock";
	} else {
		return @"Paper";
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
