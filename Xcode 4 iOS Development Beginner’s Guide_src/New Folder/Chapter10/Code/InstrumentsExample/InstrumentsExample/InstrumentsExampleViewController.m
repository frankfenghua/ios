//
//  InstrumentsExampleViewController.m
//  InstrumentsExample
//
//  Created by Steven F Daniel on 27/02/11.
//  Copyright 2011 GenieSoft Studios. All rights reserved.
//

#import "InstrumentsExampleViewController.h"

@implementation InstrumentsExampleViewController

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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Starting....");
    
    // Loop for 5000 times
    for (int i = 1; i <= 5000; i++){
        NSString *status = [[NSString alloc]initWithFormat:@"Memory Leaking...."];
        NSLog(@"Value of i: - %i and status - %@", i, status);
    }
    
    NSLog(@"Completed...");
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
