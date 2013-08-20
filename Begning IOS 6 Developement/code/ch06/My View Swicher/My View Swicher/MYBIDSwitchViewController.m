//
//  MYBIDSwitchViewController.m
//  My View Swicher
//
//  Created by fenghua on 2013-08-20.
//  Copyright (c) 2013 ClassroomM. All rights reserved.
//

#import "MYBIDSwitchViewController.h"
#import "MYBIDYellowViewController.h"
#import "MYBIDBlueViewController.h"

@interface MYBIDSwitchViewController ()

@end

@implementation MYBIDSwitchViewController

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
    self.blueViewController = [[MYBIDBlueViewController alloc]
                               initWithNibName:@"MyBlueView" bundle:nil];
    [self.view insertSubview:self.blueViewController.view atIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (self.blueViewController.view.superview == nil) {
        self.blueViewController = nil;
    } else {
        self.yellowViewController = nil;
    }
}

- (IBAction)switchViews:(id)sender {
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:1.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    if (self.yellowViewController.view.superview == nil) {
        if (self.yellowViewController == nil) {
            self.yellowViewController =
            [[MYBIDYellowViewController alloc] initWithNibName:@"MyYellowView"
                                                      bundle:nil];
        }
        [UIView setAnimationTransition:
         UIViewAnimationTransitionFlipFromRight
                               forView:self.view cache:YES];
        [self.blueViewController.view removeFromSuperview];
        [self.view insertSubview:self.yellowViewController.view atIndex:0];
    } else {
        if (self.blueViewController == nil) {
            self.blueViewController =
            [[MYBIDBlueViewController alloc] initWithNibName:@"MyBlueView"
                                                    bundle:nil];
        }
        [UIView setAnimationTransition:
         UIViewAnimationTransitionFlipFromLeft
                               forView:self.view cache:YES];
        [self.yellowViewController.view removeFromSuperview];
        [self.view insertSubview:self.blueViewController.view atIndex:0];
    }
    [UIView commitAnimations];
}
@end
