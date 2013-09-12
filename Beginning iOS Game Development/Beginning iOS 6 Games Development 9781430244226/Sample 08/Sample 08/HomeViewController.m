//
//  HomeViewController.m
//  Sample 08
//
//  Created by Lucas Jordan on 8/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "TouchEventsController.h"
#import "TapGesutureController.h"
#import "PinchGestureController.h"
#import "PanGestureController.h"
#import "RotationGestureController.h"
#import "LongPressController.h"
#import "SwipeGestureController.h"
#import "ShakeController.h"
#import "AccelerometerController.h"


@implementation HomeViewController

- (IBAction)touchEventsButtonClicked:(id)sender {
    [[self navigationController] pushViewController:[TouchEventsController new] animated:YES];
}
- (IBAction)tapGesturesButtonClicked:(id)sender {
    [[self navigationController] pushViewController:[TapGesutureController new] animated:YES];
}

- (IBAction)pinchButtonClicked:(id)sender {
    [[self navigationController] pushViewController:[PinchGestureController new] animated:YES];
}
- (IBAction)panButtonClicked:(id)sender {
    [[self navigationController] pushViewController:[PanGestureController new] animated:YES];
}
- (IBAction)rotateButtonClicked:(id)sender {
    [[self navigationController] pushViewController:[RotationGestureController new] animated:YES];
}
- (IBAction)longPressButtonClicked:(id)sender {
    [[self navigationController] pushViewController:[LongPressController new] animated:YES];
}
- (IBAction)swipeButtonClicked:(id)sender {
    [[self navigationController] pushViewController:[SwipeGestureController new] animated:YES];
}
- (IBAction)shakeButtonClicked:(id)sender {
    [[self navigationController] pushViewController:[ShakeController new] animated:YES];
}
- (IBAction)accelerometerButtonClicked:(id)sender {
    [[self navigationController] pushViewController:[AccelerometerController new] animated:YES];
}






- (IBAction)sxZX:(id)sender {
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"Gestures and Motion"];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
