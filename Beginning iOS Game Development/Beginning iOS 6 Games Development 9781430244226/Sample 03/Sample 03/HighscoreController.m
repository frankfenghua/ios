//
//  HighscoreController.m
//  Sample 03
//
//  Created by Lucas Jordan on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HighscoreController.h"


@implementation HighscoreController

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
- (void)viewDidLoad
{
    [super viewDidLoad];
    [highscores release];
    
    NSData* highscoresData = [[NSUserDefaults standardUserDefaults] dataForKey:KEY_HIGHSCORES];
    
    if (highscoresData == nil){
        highscores = [[[Highscores alloc] initWithDefaults] retain];
        [self saveHighscores];
    } else {
        highscores = [[NSKeyedUnarchiver unarchiveObjectWithData: highscoresData] retain];
    }
    [self layoutScores:nil];
}
-(void)saveHighscores{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSData* highscoresData = [NSKeyedArchiver archivedDataWithRootObject: highscores];
    [defaults setObject:highscoresData forKey: KEY_HIGHSCORES];
    [defaults synchronize];
}

-(void)layoutScores:(Score*)latestScore{
    for (UIView* subview in [highscoresView subviews]){
        [subview removeFromSuperview];
    }
    CGRect hvFrame = [highscoresView frame];
    float oneTenthHeight = hvFrame.size.height/10.0;
    float halfWidth = hvFrame.size.width/2.0;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];

    
    int index = 0;
    for (Score* score in [highscores theScores]){
        CGRect dateFrame = CGRectMake(0, index*oneTenthHeight, halfWidth, oneTenthHeight);
        UILabel* dateLabel = [[UILabel alloc] initWithFrame:dateFrame];
        [dateLabel setText: [dateFormat stringFromDate:[score date]]];
        [dateLabel setTextAlignment:UITextAlignmentLeft];
        
        [highscoresView addSubview:dateLabel];
        
        CGRect scoreFrame = CGRectMake(halfWidth, index*oneTenthHeight, halfWidth, oneTenthHeight);
        UILabel* scoreLabel = [[UILabel alloc] initWithFrame:scoreFrame];
        [scoreLabel setText:[NSString stringWithFormat:@"%d", [score score]]];
        [scoreLabel setTextAlignment:UITextAlignmentRight];
        
        [highscoresView addSubview:scoreLabel];
        
        if (latestScore != nil && latestScore == score){
            [dateLabel setTextColor:[UIColor blueColor]];
            [scoreLabel setTextColor:[UIColor blueColor]];
        } else {
            [dateLabel setTextColor:[UIColor blackColor]];
            [scoreLabel setTextColor:[UIColor blackColor]];
        }
        
        index++;
    }
    
}
-(void)addScore:(Score*)newScore{
    [highscores addScore:newScore];
    [self saveHighscores];
    [self layoutScores: newScore];
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
