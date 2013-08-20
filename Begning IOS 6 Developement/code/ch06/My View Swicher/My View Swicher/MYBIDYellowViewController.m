//
//  MYBIDYellowViewController.m
//  My View Swicher
//
//  Created by fenghua on 2013-08-20.
//  Copyright (c) 2013 ClassroomM. All rights reserved.
//

#import "MYBIDYellowViewController.h"

@interface MYBIDYellowViewController ()

@end

@implementation MYBIDYellowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)yellowButtonPressed {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Yellow View Button Pressed"
                          message:@"You pressed the button on the yellow view"
                          delegate:nil
                          cancelButtonTitle:@"Yep, I did."
                          otherButtonTitles:nil];
    [alert show];
}
@end
