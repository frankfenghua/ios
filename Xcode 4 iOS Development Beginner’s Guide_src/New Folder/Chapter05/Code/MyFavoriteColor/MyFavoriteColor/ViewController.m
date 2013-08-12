//
//  ViewController.m
//  MyFavoriteColor
//
//  Created by fenghua on 2013-08-12.
//  Copyright (c) 2013 fenghua. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize txtColor ;
@synthesize lblColor ;

- (IBAction)ChosenColor:(id)sender {
    NSString *ChosenColor = [[NSString alloc] initWithFormat:@"Your Favorite Color is %@",txtColor.text];
    
    lblColor.text = ChosenColor;
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

- (void)dealloc {
    [txtColor release];
    [lblColor release];
    [super dealloc];
}
@end
