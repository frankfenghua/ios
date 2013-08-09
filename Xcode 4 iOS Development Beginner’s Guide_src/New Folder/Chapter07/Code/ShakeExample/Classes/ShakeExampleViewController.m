//
//  ShakeExampleViewController.m
//  ShakeExample
//
//  Created by Steven F. Daniel on 8/01/11.
//  Copyright 2011 GenieSoft Studios. All rights reserved.
//

#import "ShakeExampleViewController.h"

@implementation ShakeExampleViewController


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



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor greenColor];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
-(void)viewDidAppear:(BOOL)animated {
	
	[self becomeFirstResponder];
	[super viewDidAppear:animated];
}

- (BOOL)canBecomeFirstResponder {
	
	return YES;
}
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	
	if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake)
    {
        self.view.backgroundColor=[UIColor yellowColor];
        NSLog(@"Device has been shaken");
    }
}

// Responds to the options within our Alert View Dialog
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // String will be used to hold the text chosen for the button pressed.
    NSString *buttonTitle=[alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"OK"])
       {
           self.view.backgroundColor=[UIColor greenColor];
           NSLog(@"Device has stopped shaking");
        }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake)
    {
        // Declare an instance of our Alert View dialog
        UIAlertView *dialog;

        // Initialise our Alert View Window with options
        dialog =[[UIAlertView alloc] initWithTitle:@"Device has been shaken" message:@"I was asleep, now i'm awake. Press OK to reset" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        
        // display our dialog and free the memory allocated by our dialog box
        [dialog show];
        [dialog release];
    }
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    self.view.backgroundColor=[UIColor blackColor];
	NSLog(@"Device shake has been cancelled");
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
    [super dealloc];
}

@end
