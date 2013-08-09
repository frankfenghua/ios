//
//  SwitchesSlidersSegmentsViewController.m
//  SwitchesSlidersSegments
//
//  Created by Steven F Daniel on 20/12/10.
//  Copyright 2010 GenieSoft Studios. All rights reserved.
//

#import "SwitchesSlidersSegmentsViewController.h"

@implementation SwitchesSlidersSegmentsViewController
@synthesize ourSlider,colorChoice,toggleSwitch,sliderValue,toggleValue,chosenColor;

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
    NSURL *appleUrl;
    appleUrl=[[NSURL alloc]initWithString:@"http://www.apple.com/"];
    [ourWebView loadRequest:[NSURLRequest requestWithURL: appleUrl]];
     
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
// Determines the status of our switch
- (IBAction)getSwitchValue:(id)sender {
    if ([toggleSwitch isOn]){
        toggleValue.text=@"Switch is: ON";
    }
    else
    {
        toggleValue.text=@"Switch is: OFF";
    }
}

// Gets the current value from our slider control and displays it to our label.
- (IBAction)getSliderValue:(id)sender {
    sliderValue.text=[[NSString alloc]initWithFormat:@"Slider value: %1.2f",ourSlider.value];
}

// Determines what colour has been selected, then changes the background colour of our label.
- (IBAction)getColor:(id)sender {
    
    switch (colorChoice.selectedSegmentIndex )
    {
        case 0:
            chosenColor.backgroundColor=[UIColor redColor];
            break;
        case 1:
            chosenColor.backgroundColor=[UIColor greenColor];
            break;
        case 2:
            chosenColor.backgroundColor=[UIColor blueColor];
            break;
        case 3:
            chosenColor.backgroundColor=[UIColor yellowColor];
            break;
        case 4:
            chosenColor.backgroundColor=[UIColor cyanColor];
            break;
    }
    chosenColor.text=[[NSString alloc]initWithFormat:@"You Chose: %@",[colorChoice titleForSegmentAtIndex:colorChoice.selectedSegmentIndex]];
    
    
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
    [toggleSwitch release];
    [colorChoice release];
    [ourWebView release];
    [sliderValue release];
    [toggleValue release];
    [chosenColor release];
    [ourSlider release];
    [super dealloc];
}

@end
