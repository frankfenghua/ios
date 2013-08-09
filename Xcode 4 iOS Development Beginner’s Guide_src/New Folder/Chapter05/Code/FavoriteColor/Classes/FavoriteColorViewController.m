//
//  FavoriteColorViewController.m
//  FavoriteColor
//
//  Created by GENIESOFT-MACBOOK on 19/12/10.
//  Copyright 2010 GENIESOFT STUDIOS. All rights reserved.
//

#import "FavoriteColorViewController.h"

@implementation FavoriteColorViewController
@synthesize txtColor;
@synthesize lblColor;


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction)ChosenColor:(id)sender {
    NSString *ChosenColor = [[NSString alloc] initWithFormat:@"Your Favorite Color is %@",txtColor.text];
    lblColor.text = ChosenColor;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [txtColor release];
    [lblColor release];
    [super dealloc];
}

@end
