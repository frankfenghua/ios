//
//  BIDSwitchViewController.m
//  View Switcher
//

#import "BIDSwitchViewController.h"
#import "BIDYellowViewController.h"
#import "BIDBlueViewController.h"

@interface BIDSwitchViewController ()

@end

@implementation BIDSwitchViewController

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
    self.blueViewController = [[BIDBlueViewController alloc]
                               initWithNibName:@"BlueView" bundle:nil];
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
    [UIView beginAnimations:@"View Flip" context:nil];      // bold
    [UIView setAnimationDuration:10.25];                     // bold
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];   // bold
    if (self.yellowViewController.view.superview == nil) {
        if (self.yellowViewController == nil) {
            self.yellowViewController =
            [[BIDYellowViewController alloc] initWithNibName:@"YellowView"
                                                      bundle:nil];
        }
        [UIView setAnimationTransition:                         // bold
         UIViewAnimationTransitionFlipFromRight                 // bold
                               forView:self.view cache:YES];    // bold
        
        [self.blueViewController.view removeFromSuperview];
        [self.view insertSubview:self.yellowViewController.view atIndex:0];
    } else {
        if (self.blueViewController == nil) {
            self.blueViewController =
            [[BIDBlueViewController alloc] initWithNibName:@"BlueView"
                                                    bundle:nil];
        }
        [UIView setAnimationTransition:                         // bold
         UIViewAnimationTransitionFlipFromLeft                  // bold
                               forView:self.view cache:YES];    // bold
        [self.yellowViewController.view removeFromSuperview];
        [self.view insertSubview:self.blueViewController.view atIndex:0];
    }
    [UIView commitAnimations];                                   // bold
}

@end
