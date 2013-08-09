//
//  DebuggingExampleViewController.m
//  DebuggingExample
//
//  Created by Steven F Daniel on 23/01/11.
//  Copyright 2011 GenieSoft Studios. All rights reserved.
//

#import "DebuggingExampleViewController.h"

@implementation DebuggingExampleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
//- (void)loadView
//{
//    
//}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    NSLog(@"Hello, welcome to XCode 4!");
    
    int x = 42;
    float y = 150.00;
    NSLog(@"Value of x = %i, Value of y = %f", x, y);  
    
    self.view.backgroundColor = [UIColor redColor];
    NSLog(@"Value of 100 divided by 0 = %i", (100 / 0));  
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
