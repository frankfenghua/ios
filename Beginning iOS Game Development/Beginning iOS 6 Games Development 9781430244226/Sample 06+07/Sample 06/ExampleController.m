//
//  SampleController.m
//  Sample 06
//
//  Created by Lucas Jordan on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExampleController.h"


@implementation ExampleController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    example01Controller = nil;
    example02Controller = nil;
    example03Controller = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

- (IBAction)example01ButtonTouched:(id)sender {
    [example01Controller doSetup];
    [[self navigationController] pushViewController:example01Controller animated:YES];
}
- (IBAction)example02ButtonTouched:(id)sender {
    [example02Controller doSetup];
    [[self navigationController] pushViewController:example02Controller animated:YES];
}

- (IBAction)example03ButtonTouched:(id)sender {
    [example03Controller doSetup];
    [[self navigationController] pushViewController:example03Controller animated:YES];
}
@end
