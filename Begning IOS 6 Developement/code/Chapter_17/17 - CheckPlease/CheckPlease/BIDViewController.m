//
//  BIDViewController.m
//  CheckPlease
//

#import "BIDViewController.h"
#import "BIDCheckMarkRecognizer.h"

@implementation BIDViewController

- (void)doCheck:(BIDCheckMarkRecognizer *)check
{
    self.label.text = @"Checkmark";
    [self performSelector:@selector(eraseLabel)
               withObject:nil afterDelay:1.6];
}

- (void)eraseLabel
{
    self.label.text = @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    BIDCheckMarkRecognizer *check = [[BIDCheckMarkRecognizer alloc]
                                     initWithTarget:self action:@selector(doCheck:)];
    [self.view addGestureRecognizer:check];
}

@end
