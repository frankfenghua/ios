//
//  BIDViewController.m
//  Swap
//

#define degreesToRadians(x) (M_PI * (x) / 180.0)

#import "BIDViewController.h"

@interface BIDViewController ()

@end

@implementation BIDViewController

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)
interfaceOrientation duration:(NSTimeInterval)duration {
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view = self.portrait;
        self.view.transform = CGAffineTransformIdentity;
        self.view.transform =
        CGAffineTransformMakeRotation(degreesToRadians(0));
        self.view.bounds = CGRectMake(0.0, 0.0, 320.0, 460.0);
    }
    else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.view = self.landscape;
        self.view.transform = CGAffineTransformIdentity;
        self.view.transform =
        CGAffineTransformMakeRotation(degreesToRadians(-90));
        self.view.bounds = CGRectMake(0.0, 0.0, 480.0, 300.0);
    }
    else if (interfaceOrientation ==
             UIInterfaceOrientationLandscapeRight) {
        self.view = self.landscape;
        self.view.transform = CGAffineTransformIdentity;
        self.view.transform =
        CGAffineTransformMakeRotation(degreesToRadians(90));
        self.view.bounds = CGRectMake(0.0, 0.0, 480.0, 300.0);
    }
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

- (IBAction)buttonTapped:(id)sender {
#ifdef FIRST_VERSION
    NSString *message = nil;
    
    if ([self.foos containsObject:sender])
        message = @"Foo button pressed";
    else
        message = @"Bar button pressed";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
#endif
    if ([self.foos containsObject:sender]) {
        for (UIButton *oneFoo in self.foos) {
            oneFoo.hidden = YES;
        }
    }
    else {
        for (UIButton *oneBar in self.bars) {
            oneBar.hidden = YES;
        }
    }
}
@end
