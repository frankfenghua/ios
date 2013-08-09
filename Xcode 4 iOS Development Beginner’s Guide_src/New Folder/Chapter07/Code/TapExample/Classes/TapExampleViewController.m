//
//  TapExampleViewController.m
//  TapExample
//
//  Created by Steven F. Daniel on 8/01/11.
//  Copyright 2011 GenieSoft Studios. All rights reserved.
//

#import "TapExampleViewController.h"

@implementation TapExampleViewController
@synthesize tapCount;



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

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event   {
    NSString *labelOutput;
    UITouch *touch = [[event allTouches] anyObject];
    labelOutput = [NSString stringWithFormat:@"You tapped %i times.",[touch tapCount]];
    tapCount.text=labelOutput;
    switch ([touch tapCount])
    {
        case 1:
            self.view.backgroundColor=[UIColor redColor];
            break;
        case 2:
            self.view.backgroundColor=[UIColor greenColor];
            break;
        case 3:
            self.view.backgroundColor=[UIColor blueColor];
            break;
        case 4:
            self.view.backgroundColor=[UIColor yellowColor];
            break;
        case 5:
            self.view.backgroundColor=[UIColor orangeColor];
            break;
        default:
            self.view.backgroundColor=[UIColor redColor];
            break;
    }
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
    [tapCount release];
    [super dealloc];
}

@end
