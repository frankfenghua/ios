//
//  BIDViewController.m
//  ShakeAndBreak
//

#import "BIDViewController.h"
#import <CoreMotion/CoreMotion.h>
#import <AudioToolbox/AudioToolbox.h>

#define kUpdateInterval         (1.0 / 10.0)
#define kAccelerationThreshold  2.0

@interface BIDViewController ()
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) NSOperationQueue *queue;
@property (assign, nonatomic) BOOL brokenScreenShowing;
@property (assign, nonatomic) SystemSoundID soundID;
@property (strong, nonatomic) UIImage *fixed;
@property (strong, nonatomic) UIImage *broken;
@end

@implementation BIDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"glass"
                                         withExtension:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url,
                                     &_soundID);
    self.fixed = [UIImage imageNamed:@"home.png"];
    self.broken = [UIImage imageNamed:@"homebroken.png"];
    
    self.imageView.image = self.fixed;
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = kUpdateInterval;
    self.queue = [[NSOperationQueue alloc] init];
    [self.motionManager startAccelerometerUpdatesToQueue:self.queue
                                        withHandler:
     ^(CMAccelerometerData *accelerometerData, NSError *error){
         if (error) {
             [self.motionManager stopAccelerometerUpdates];
         } else {
             if (!self.brokenScreenShowing) {
                 CMAcceleration acceleration = accelerometerData.acceleration;
                 if (acceleration.x > kAccelerationThreshold
                     || acceleration.y > kAccelerationThreshold
                     || acceleration.z > kAccelerationThreshold) {
                     [self.imageView performSelectorOnMainThread:@selector(setImage:)
                                                 withObject:self.broken
                                              waitUntilDone:NO];
                     AudioServicesPlaySystemSound(self.soundID);
                     self.brokenScreenShowing = YES;
                 }
             }
         }
     }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.imageView.image = self.fixed;
    self.brokenScreenShowing = NO;
}

@end
