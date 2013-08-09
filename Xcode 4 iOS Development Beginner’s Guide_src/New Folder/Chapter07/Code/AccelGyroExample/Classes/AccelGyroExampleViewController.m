//
//  AccelGyroExampleViewController.m
//  AccelGyroExample
//
//  Created by Steven F Daniel on 16/01/11.
//  Copyright 2011 GenieSoft Studios. All rights reserved.
//

#import "AccelGyroExampleViewController.h"

@implementation AccelGyroExampleViewController

@synthesize motionManager;

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
// Handle processing of the Accelerometer 
-(void)handleAcceleration:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    UIAccelerationValue xAxes;
    UIAccelerationValue yAxes;
    UIAccelerationValue zAxes;
    
    xAxes = acceleration.x;     
    yAxes = acceleration.y;
    zAxes = acceleration.z;
    
    if (xAxes > 0.5) {         // Check to see if we are Moving Right
        self.view.backgroundColor = [UIColor purpleColor]; 
    } else if (xAxes < -0.5) { // Check to see if we are Moving Left
        self.view.backgroundColor = [UIColor redColor];
    } else if (yAxes > 0.5) {  // Check to see if we are Upside Down.
        self.view.backgroundColor = [UIColor yellowColor]; 
    } else if (yAxes < -0.5) { // Check to see if we are Standing Up.
        self.view.backgroundColor = [UIColor blueColor];
    } else if (zAxes > 0.5) {  // Check to see if we are Facing Up.
        self.view.backgroundColor = [UIColor magentaColor]; 
    } else if (zAxes < -0.5) { // Check to see if we are Facing Down.
        self.view.backgroundColor = [UIColor greenColor];
    }
    
    double value = fabs(xAxes);
    if (value > 1.0) { value = 1.0;}
    self.view.alpha = value;
}
// Handles rotation of the Gyroscope
- (void)doGyroRotation:(CMRotationRate)rotation {
    
    double value = (fabs(rotation.x)+fabs(rotation.y)+fabs(rotation.z))/8.0;
    if (value > 1.0) { value = 1.0;}
    self.view.alpha = value;
    
}
// Checks to see if Gyroscope is available on the device
- (BOOL) isGyroscopeAvailable
{
#ifdef __IPHONE_4_0
	CMMotionManager *gyroManager = [[CMMotionManager alloc] init];
    gyroManager.gyroUpdateInterval = 1.0/60.0;
	BOOL gyroAvailable = gyroManager.gyroAvailable;
	[gyroManager release];
	return gyroAvailable;
#else
	return NO;
#endif
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    // Set up the accelerometer
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.updateInterval = 0.5;
    accelerometer.delegate = self;
    
    // Perform a check to see if the device supports the Gyroscope feature
    if ([self isGyroscopeAvailable] == YES) {
        motionManager = [[CMMotionManager alloc] init];
        [motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue] 
        withHandler:^(CMGyroData *gyroData, NSError *error) 
        {
          [self doGyroRotation:gyroData.rotationRate];
        }];
    }
    else
    {
        // Device does not support the gyroscope feature 
        NSLog(@"No Gyroscope detected. Upgrade to an iPhone 4.");
        [motionManager release];
    }
    
    self.view.backgroundColor = [UIColor magentaColor]; 
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
    [motionManager release];
    [super dealloc];
}

@end
