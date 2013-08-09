//
//  TextViewsandButtonsViewController.m
//  TextViewsandButtons
//
//  Created by GENIESOFT-MACBOOK on 19/12/10.
//  Copyright 2010 GENIESOFT STUDIOS. All rights reserved.
//

#import "TextViewsandButtonsViewController.h"

@implementation TextViewsandButtonsViewController
@synthesize txtGender;
@synthesize txtName;
@synthesize txtJob;
@synthesize txtTextView;


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
- (IBAction)generateTextView:(id)sender {
    NSString *TextView = [[NSString alloc] initWithFormat:@"Name: %@\nGender: %@\nJob: %@\n",txtName.text,txtGender.text,txtJob.text ];
    
    txtTextView.text=TextView;
    txtTextView.textColor=[UIColor redColor];
}

- (IBAction)hideKeyboard:(id)sender {
    [txtName resignFirstResponder];
    [txtGender resignFirstResponder];
    [txtJob resignFirstResponder];
    [txtTextView resignFirstResponder];
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
    [txtName release];
    [txtGender release];
    [txtJob release];
    [txtTextView release];
    [super dealloc];
}

@end
