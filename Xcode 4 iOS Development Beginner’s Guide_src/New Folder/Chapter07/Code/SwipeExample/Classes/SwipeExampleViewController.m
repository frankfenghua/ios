//
//  SwipeExampleViewController.m
//  SwipeExample
//
//  Created by Steven F Daniel on 15/01/11.
//  Copyright 2011 GenieSoft Studios. All rights reserved.
//

#import "SwipeExampleViewController.h"

@implementation SwipeExampleViewController


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
  self.view.backgroundColor=[UIColor blackColor];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    currentStartingPoint = [touch locationInView:self.view];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [touch locationInView:self.view];  
    
    // Calculate how far the user’s finger has moved both horizontally and vertically from its starting position. 
    CGFloat deltaX = fabsf(currentStartingPoint.x - currentPosition.x);
    CGFloat deltaY = fabsf(currentStartingPoint.y - currentPosition.y);
    
    // Check to see if we are currently doing a Horizontal Swipe
    if(deltaX >= minGestureLength && deltaY <= allowableVariance){
       // Horizontal Swipe detected, so set our background color to Red
       // reset the background color to black after our delay of 3 seconds have passed.
       self.view.backgroundColor = [UIColor redColor];
       [self performSelector:@selector(resetBackground) withObject:nil afterDelay:delayFactor];
    }
    // Check to see if we are currently doing a Vertical Swipe
    else if(deltaY >= minGestureLength && deltaX <= allowableVariance){
        // Vertical Swipe Detected.
        self.view.backgroundColor=[UIColor blueColor];
       // [self performSelector:@selector(resetBackground) withObject:nil afterDelay:10];
        [self performSelector:@selector(resetBackground) withObject:nil afterDelay:delayFactor];
    }
}
// Handles resetting the background
-(void)resetBackground
{
    self.view.backgroundColor=[UIColor blackColor];
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
