//
//  BIDViewController.m
//  MotionMonitor
//

#import "BIDViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface BIDViewController ()
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) NSTimer *updateTimer;
@end

@implementation BIDViewController

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.motionManager = [[CMMotionManager alloc] init];
    if (self.motionManager.accelerometerAvailable) {
        self.motionManager.accelerometerUpdateInterval = 1.0 / 10.0;
        [self.motionManager startAccelerometerUpdates];
    } else {
        self.accelerometerLabel.text = @"This device has no accelerometer.";
    }
    if (self.motionManager.gyroAvailable) {
        self.motionManager.gyroUpdateInterval = 1.0/10.0;
        [self.motionManager startGyroUpdates];
    } else {
        self.gyroscopeLabel.text = @"This device has no gyroscope.";
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 10.0
                                                        target:self
                                                      selector:@selector(updateDisplay)
                                                      userInfo:nil
                                                       repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.updateTimer invalidate];
    self.updateTimer = nil;
}

- (void)dummy
{
    static NSInteger shakeCount = 0;
    static NSDate *shakeStart;
    
    NSDate *now = [[NSDate alloc] init];
    NSDate *checkDate = [[NSDate alloc] initWithTimeInterval:1.5f
                                                   sinceDate:shakeStart];
    if ([now compare:checkDate] == NSOrderedDescending
        || shakeStart == nil) {
        shakeCount = 0;
        shakeStart = [[NSDate alloc] init];
    }
    
    CMAccelerometerData *accelerometerData = self.motionManager.accelerometerData;
    if (fabsf(accelerometerData.acceleration.x) > 2.0
        || fabsf(accelerometerData.acceleration.y) > 2.0
        || fabsf(accelerometerData.acceleration.z) > 2.0)
    {
        shakeCount++;
        if (shakeCount > 4) {
            // Do something
            shakeCount = 0;
            shakeStart = [[NSDate alloc] init];
        }
    }
}

- (void)updateDisplay
{
    if (self.motionManager.accelerometerAvailable) {
        CMAccelerometerData *accelerometerData = self.motionManager.accelerometerData;
        self.accelerometerLabel.text  = [NSString stringWithFormat:
                                    @"Accelerometer\n-----------\nx: %+.2f\ny: %+.2f\nz: %+.2f",
                                    accelerometerData.acceleration.x,
                                    accelerometerData.acceleration.y,
                                    accelerometerData.acceleration.z];
    }
    if (self.motionManager.gyroAvailable) {
        CMGyroData *gyroData = self.motionManager.gyroData;
        self.gyroscopeLabel.text = [NSString stringWithFormat:
                               @"Gyroscope\n--------\nx: %+.2f\ny: %+.2f\nz: %+.2f",
                               gyroData.rotationRate.x,
                               gyroData.rotationRate.y,
                               gyroData.rotationRate.z];
    }
}

@end
