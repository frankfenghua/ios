//
//  PinchExampleViewController.m
//  PinchExample
//
//  Created by Steven F Daniel on 15/01/11.
//  Copyright 2011 GenieSoft Studios. All rights reserved.
//

#import "PinchExampleViewController.h"

@implementation PinchExampleViewController



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
	
    // initialise and create our Box 
	float boxSize = 100.0;
	CGRect ourBoxRect = CGRectMake(100,150,boxSize,boxSize);
	ourBox = [[UIView alloc] initWithFrame:ourBoxRect];
	ourBox.backgroundColor = [UIColor greenColor];
    
	// we need to tell our object that we want to be able to handle multiple touches
    ourBox.multipleTouchEnabled = YES;
	
    // initialise our view background color and then add the box to the view.
    self.view.backgroundColor = [UIColor blackColor];
	[self.view addSubview:ourBox];	
}

// Calculate the distance between 
CGFloat distanceBetweenPoints(CGPoint pt1, CGPoint pt2) {
	CGFloat distance;
	
	CGFloat xDifferenceSquared = pow(pt1.x - pt2.x, 2);
	CGFloat yDifferenceSquared = pow(pt1.y - pt2.y, 2);
	distance = sqrt(xDifferenceSquared + yDifferenceSquared);
	
	return distance;
}

CGAffineTransform transformWithScale(CGAffineTransform oldTransform, UITouch *touch1, UITouch *touch2) {
	
	CGPoint touch1Location = [touch1 locationInView:nil];
	CGPoint touch1PreviousLocation = [touch1 previousLocationInView:nil];
	CGPoint touch2Location = [touch2 locationInView:nil];
	CGPoint touch2PreviousLocation = [touch2 previousLocationInView:nil];
	
	
	// Get distance between points
	CGFloat distance = distanceBetweenPoints(touch1Location,touch2Location);
	CGFloat prevDistance = distanceBetweenPoints(touch1PreviousLocation, touch2PreviousLocation);
	
	// Figure new scale
	CGFloat scaleRatio = distance / prevDistance;
	CGAffineTransform newTransform = CGAffineTransformScale(oldTransform, scaleRatio, scaleRatio);
	
	// Return result
	return newTransform;
}

CGAffineTransform transformWithRotation(CGAffineTransform oldTransform, UITouch *touch, UIView *view, id superview) {
	CGPoint pt1 = [touch locationInView:superview];
	CGPoint pt2 = [touch previousLocationInView:superview];
	CGPoint center = view.center;
	CGFloat angle1 = atan2( center.y - pt2.y, center.x - pt2.x );
	CGFloat angle2 = atan2( center.y - pt1.y, center.x - pt1.x );
    
	CGAffineTransform newTransform = CGAffineTransformRotate(oldTransform, angle2-angle1);
    
	// Return result
	return newTransform;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	if ([[event touchesForView:ourBox] count] == 1)
	{
		UITouch *touch  = [[[event touchesForView:ourBox] allObjects] objectAtIndex:0];
		ourBox.transform = transformWithRotation(ourBox.transform,touch,ourBox,self.view);
	}
	
	if ([[event touchesForView:ourBox] count] == 2)
	{
		UITouch *touch1  = [[[event touchesForView:ourBox] allObjects] objectAtIndex:0];
		UITouch *touch2 = [[[event touchesForView:ourBox] allObjects] objectAtIndex:1];
		ourBox.transform = transformWithScale(ourBox.transform, touch1, touch2);
	}
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
    [ourBox release];
    [super dealloc];
}

@end
