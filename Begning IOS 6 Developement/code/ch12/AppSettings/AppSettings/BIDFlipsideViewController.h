//
//  BIDFlipsideViewController.h
//  AppSettings
//

#import <UIKit/UIKit.h>

@class BIDFlipsideViewController;

@protocol BIDFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(BIDFlipsideViewController *)controller;
@end

@interface BIDFlipsideViewController : UIViewController

@property (weak, nonatomic) id <BIDFlipsideViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UISwitch *engineSwitch;
@property (weak, nonatomic) IBOutlet UISlider *warpFactorSlider;

- (void)refreshFields;
- (IBAction)engineSwitchTapped;
- (IBAction)warpSliderTouched;
- (IBAction)done:(id)sender;

@end
