//
//  BIDViewController.m
//  Swipes
//

#import "BIDViewController.h"

@interface BIDViewController ()

@end

#define kMinimumGestureLength    25
#define kMaximumVariance         5

@implementation BIDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UISwipeGestureRecognizer *vertical =
        [[UISwipeGestureRecognizer alloc]
         initWithTarget:self action:@selector(reportVerticalSwipe:)];
    vertical.direction = UISwipeGestureRecognizerDirectionUp|
                         UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:vertical];
    
    UISwipeGestureRecognizer *horizontal =
        [[UISwipeGestureRecognizer alloc]
          initWithTarget:self action:@selector(reportHorizontalSwipe:)];
    horizontal.direction = UISwipeGestureRecognizerDirectionLeft|
                           UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:horizontal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)eraseText
{
    self.label.text = @"";
}

- (void)reportHorizontalSwipe:(UIGestureRecognizer *)recognizer
{
    self.label.text = @"Horizontal swipe detected";
    [self performSelector:@selector(eraseText) withObject:nil afterDelay:2];
}

- (void)reportVerticalSwipe:(UIGestureRecognizer *)recognizer
{
    self.label.text = @"Vertical swipe detected";
    [self performSelector:@selector(eraseText) withObject:nil afterDelay:2];
}

@end
