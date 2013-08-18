//
//  ViewController.m
//  iPhone_1
//
//  Created by fenghua on 2013-08-17.
//  Copyright (c) 2013 ClassroomM. All rights reserved.
//

#import "ViewController.h"

/*
 Note that Xcode added a class extension to your class that you can us to define private methods and properties
 
 Private methods are methods that will be used only from within the implementation section of your class
 see chapter 11 Categories and Protocols covered class entensions
 */
@interface ViewController ()

@end


@implementation ViewController
@synthesize display;

- (IBAction)click1:(id)sender {
    NSLog(@"hello");
    display.text = @"1";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
