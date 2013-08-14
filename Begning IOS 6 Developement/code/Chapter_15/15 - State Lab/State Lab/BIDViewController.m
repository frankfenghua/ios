//
//  BIDViewController.m
//  State Lab
//

#import "BIDViewController.h"

@interface BIDViewController ()

@end

@implementation BIDViewController {
    BOOL animate;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self
                   selector:@selector(applicationWillResignActive)
                       name:UIApplicationWillResignActiveNotification
                     object:nil];
        [center addObserver:self
                   selector:@selector(applicationDidBecomeActive)
                       name:UIApplicationDidBecomeActiveNotification
                     object:nil];
        [center addObserver:self
                   selector:@selector(applicationDidEnterBackground)
                       name:UIApplicationDidEnterBackgroundNotification
                     object:nil];
        [center addObserver:self
                   selector:@selector(applicationWillEnterForeground)
                       name:UIApplicationWillEnterForegroundNotification
                     object:nil];
    }
    return self;
}

- (void)applicationWillResignActive
{
    NSLog(@"VC: %@", NSStringFromSelector(_cmd));
    animate = NO;
}

- (void)applicationDidBecomeActive
{
    NSLog(@"VC: %@", NSStringFromSelector(_cmd));
    animate = YES;
    [self rotateLabelDown];
}

- (void)applicationDidEnterBackground
{
    NSLog(@"VC: %@", NSStringFromSelector(_cmd));
    UIApplication *app = [UIApplication sharedApplication];
    
    __block UIBackgroundTaskIdentifier taskId;
    taskId = [app beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"Background task ran out of time and was terminated.");
        [app endBackgroundTask:taskId];
    }];
    
    if (taskId == UIBackgroundTaskInvalid) {
        NSLog(@"Failed to start background task!");
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"Starting background task with %f seconds remaining",
              app.backgroundTimeRemaining);
        self.smiley = nil;
        self.smileyView.image = nil;
        NSInteger selectedIndex = self.segmentedControl.selectedSegmentIndex;
        [[NSUserDefaults standardUserDefaults] setInteger:selectedIndex
                                                   forKey:@"selectedIndex"];
        // simulate a lengthy (25 seconds) procedure
        [NSThread sleepForTimeInterval:25];
        
        NSLog(@"Finishing background task with %f seconds remaining",
              app.backgroundTimeRemaining);
        [app endBackgroundTask:taskId];
    });
}

- (void)applicationWillEnterForeground
{
    NSLog(@"VC: %@", NSStringFromSelector(_cmd));
    NSString *smileyPath = [[NSBundle mainBundle] pathForResource:@"smiley"
                                                           ofType:@"png"];
    self.smiley = [UIImage imageWithContentsOfFile:smileyPath];
    self.smileyView.image = self.smiley;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CGRect bounds = self.view.bounds;
    CGRect labelFrame = CGRectMake(bounds.origin.x, CGRectGetMidY(bounds) - 50,
                                   bounds.size.width, 100);
    self.label = [[UILabel alloc] initWithFrame:labelFrame];
    self.label.font = [UIFont fontWithName:@"Helvetica" size:70];
    self.label.text = @"Bazinga!";
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.backgroundColor = [UIColor clearColor];
    
    // smiley.png is 84 x 84
    CGRect smileyFrame = CGRectMake(CGRectGetMidX(bounds) - 42,
                                    CGRectGetMidY(bounds)/2 - 42,
                                    84, 84);
    self.smileyView = [[UIImageView alloc] initWithFrame:smileyFrame];
    self.smileyView.contentMode = UIViewContentModeCenter;
    NSString *smileyPath = [[NSBundle mainBundle] pathForResource:@"smiley"
                                                           ofType:@"png"];
    self.smiley = [UIImage imageWithContentsOfFile:smileyPath];
    self.smileyView.image = self.smiley;
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:
                             [NSArray arrayWithObjects:
                              @"One", @"Two", @"Three", @"Four", nil]] ;
    self.segmentedControl.frame = CGRectMake(bounds.origin.x + 20,
                                             50,
                                             bounds.size.width - 40, 30);
    
    //[self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.smileyView];
    [self.view addSubview:self.label];
    
    NSNumber *indexNumber = indexNumber = [[NSUserDefaults standardUserDefaults]
                                           objectForKey:@"selectedIndex"];
    if (indexNumber) {
        NSInteger selectedIndex = [indexNumber intValue];
        self.segmentedControl.selectedSegmentIndex = selectedIndex;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rotateLabelDown
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.label.transform = CGAffineTransformMakeRotation(M_PI);
                     }
                     completion:^(BOOL finished){
                         [self rotateLabelUp];
                     }];
}

- (void)rotateLabelUp
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.label.transform = CGAffineTransformMakeRotation(0);
                     }
                     completion:^(BOOL finished){
                         if (animate) {
                             [self rotateLabelDown];
                         }
                     }];
}

@end
