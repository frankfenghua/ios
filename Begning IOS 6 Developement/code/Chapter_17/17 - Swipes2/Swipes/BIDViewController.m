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
    for (NSUInteger touchCount = 1; touchCount <= 5; touchCount++) {
        UISwipeGestureRecognizer *vertical;
        vertical = [[UISwipeGestureRecognizer alloc]
                    initWithTarget:self action:@selector(reportVerticalSwipe:)];
        vertical.direction = UISwipeGestureRecognizerDirectionUp
        | UISwipeGestureRecognizerDirectionDown;
        vertical.numberOfTouchesRequired = touchCount;
        [self.view addGestureRecognizer:vertical];
        
        UISwipeGestureRecognizer *horizontal;
        horizontal = [[UISwipeGestureRecognizer alloc]
                       initWithTarget:self action:@selector(reportHorizontalSwipe:)];
        horizontal.direction = UISwipeGestureRecognizerDirectionLeft
        | UISwipeGestureRecognizerDirectionRight;
        horizontal.numberOfTouchesRequired = touchCount;
        [self.view addGestureRecognizer:horizontal];
    }
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

- (NSString *)descriptionForTouchCount:(NSUInteger)touchCount
{
    switch (touchCount) {
        case 1:
            return @"Single";
        case 2:
            return @"Double ";
        case 3:
            return @"Triple ";
        case 4:
            return @"Quadruple ";
        case 5:
            return @"Quintuple ";
        default:
            return @"";
    }
}

- (void)reportHorizontalSwipe:(UIGestureRecognizer *)recognizer
{
    self.label.text = @"Horizontal swipe detected";
    self.label.text = [NSString stringWithFormat:@"%@Horizontal swipe detected",
                       [self descriptionForTouchCount:[recognizer numberOfTouches]]];
    [self performSelector:@selector(eraseText) withObject:nil afterDelay:2];
}

- (void)reportVerticalSwipe:(UIGestureRecognizer *)recognizer
{
    self.label.text = @"Vertical swipe detected";
    self.label.text = [NSString stringWithFormat:@"%@Vertical swipe detected",
                       [self descriptionForTouchCount:[recognizer numberOfTouches]]];
    [self performSelector:@selector(eraseText) withObject:nil afterDelay:2];
}

@end
