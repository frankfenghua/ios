//
//  BIDCustomPickerViewController.m
//  Pickers
//

#import "BIDCustomPickerViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation BIDCustomPickerViewController {
    SystemSoundID winSoundID;
    SystemSoundID crunchSoundID;
}

-(void)showButton
{
    self.button.hidden = NO;
}

-(void)playWinSound
{
    if (winSoundID == 0) {
        NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"win"
                                                  withExtension:@"wav"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL,
                                         &winSoundID);
    }
    AudioServicesPlaySystemSound(winSoundID);
    self.winLabel.text = @"WINNING!";
    [self performSelector:@selector(showButton)
               withObject:nil
               afterDelay:1.5];
}

- (IBAction)spin
{
    BOOL win = NO;
    int numInRow = 1;
    int lastVal = -1;
    for (int i = 0; i < 5; i++) {
        int newValue = random() % [self.images count];
        
        if (newValue == lastVal) {
            numInRow++;
        } else {
            numInRow = 1;
        }
        
        lastVal = newValue;
        [self.picker selectRow:newValue inComponent:i animated:YES];
        [self.picker reloadComponent:i];
        if (numInRow >= 3) {
            win = YES;
        }
    }
    
    if (crunchSoundID == 0) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"crunch"
                                                         ofType:@"wav"];
        NSURL *soundURL = [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL,
                                         &crunchSoundID);
    }
    AudioServicesPlaySystemSound(crunchSoundID);
    
    if (win) {
        [self performSelector:@selector(playWinSound)
                   withObject:nil
                   afterDelay:.5];
    } else {
        [self performSelector:@selector(showButton)
                   withObject:nil
                   afterDelay:.5];
    }
    self.button.hidden = YES;
    self.winLabel.text = @"";

    if (win) {
        self.winLabel.text = @"WIN!";
    } else {
        self.winLabel.text = @"";
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.images = @[[UIImage imageNamed:@"seven"],
    [UIImage imageNamed:@"bar"], [UIImage imageNamed:@"crown"],
    [UIImage imageNamed:@"cherry"], [UIImage imageNamed:@"lemon"],
    [UIImage imageNamed:@"apple"]];
    
    srandom(time(NULL));
}

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 5;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [self.images count];
}

#pragma mark Picker Delegate Methods
- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIImage *image = self.images[row];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    return imageView;
}

@end
