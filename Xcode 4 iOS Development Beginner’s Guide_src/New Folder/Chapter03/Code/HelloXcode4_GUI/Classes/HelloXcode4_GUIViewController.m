//
//  HelloXcode4_GUIViewController.m
//  HelloXcode4_GUI
//
//  Created by Steven F Daniel on 13/11/10.
//  Copyright (c) 2010 GenieSoft Studios. All rights reserved.
//

#import "HelloXcode4_GUIViewController.h"

@implementation HelloXcode4_GUIViewController
- (IBAction)btnOK:(id)sender {
    NSString *WelcomeMsg=[[NSString alloc] initWithFormat:@"Welcome to iOS Programming %@",txtUsername.text];
    
    lblOutput.text=WelcomeMsg;
    lblOutput.textColor=[UIColor blueColor];
}

- (IBAction)hideKeyboard:(id)sender {
    [txtUsername resignFirstResponder];
}

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


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
   // return (interfaceOrientation == UIInterfaceOrientationPortrait);
   return YES;
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
    [txtUsername release];
    [txtUsername release];
    [lblOutput release];
    [txtUsername release];
    [lblOutput release];
    [super dealloc];
}

@end
