//
//  BIDYellowViewController.m
//  View Switcher
//

#import "BIDYellowViewController.h"

@interface BIDYellowViewController ()

@end

@implementation BIDYellowViewController

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
