//
//  HelloXcode4ViewController.m
//  HelloXcode4
//
//  Created by Steven F Daniel on 31/10/10.
//  Copyright (c) 2010 GenieSoft Studios. All rights reserved.
//

#import "HelloXcode4ViewController.h"


@implementation HelloXcode4ViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
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
// Implement loadView to create a view hierarchy programmatically,
// without using a nib file.
- (void) loadView
{
    // Create a frame that sets the bounds of the view
    CGRect frame = CGRectMake(0, 0, 960, 480);
    
    // Allocate memory for use by our view
    self.view = [[UIView alloc] initWithFrame:frame];
    
    // Set the view's background color
    self.view.backgroundColor=[UIColor greenColor];   
    
    // set the position of our text label
    frame = CGRectMake(10, 170, 350, 50);
    
    // allocate memory for our label
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    
    // Assign some text to our label control
    label.text = @"iPhone Programming using Xcode 4";
    label.textColor = [UIColor redColor];
    
    // now, add the label to the view
    [self.view addSubview:label];
    
    // it is a good idea to release the memory allocated by our label
    [label release];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}


@end
