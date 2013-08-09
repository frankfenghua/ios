//
//  OrientationExampleViewController.m
//  OrientationExample
//
//  Created by Steven F Daniel on 16/01/11.
//  Copyright 2011 GenieSoft Studios. All rights reserved.
//

#import "OrientationExampleViewController.h"

@implementation OrientationExampleViewController


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

- (void)hasOrientationChanged:(NSNotification *)notification {
    
    
    UIDeviceOrientation currentOrientation;
    currentOrientation = [[UIDevice currentDevice] orientation];
    
    switch (currentOrientation) {
        case UIDeviceOrientationFaceUp:
            self.view.backgroundColor = [UIColor brownColor];
            break;
        case UIDeviceOrientationFaceDown:
            self.view.backgroundColor = [UIColor magentaColor];
            break;
        case UIDeviceOrientationPortrait:
            self.view.backgroundColor = [UIColor blueColor];
            break;
        case UIDeviceOrientationPortraitUpsideDown: 
            self.view.backgroundColor = [UIColor greenColor];
            break;
        case UIDeviceOrientationLandscapeLeft:  
            self.view.backgroundColor = [UIColor redColor];
            break;
        case UIDeviceOrientationLandscapeRight: 
            self.view.backgroundColor = [UIColor purpleColor]; 
            break;
        default:
            // Handle cases where orientation fails
            self.view.backgroundColor = [UIColor blackColor];
            break;
    }
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [[UIDevice currentDevice]beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self selector:@selector(hasOrientationChanged:) 
     name:@"UIDeviceOrientationDidChangeNotification" 
     object:nil];
    
    [super viewDidLoad];
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
    [super dealloc];
}

@end
