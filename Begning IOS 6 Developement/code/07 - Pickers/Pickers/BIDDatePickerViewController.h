//
//  BIDDatePickerViewController.h
//  Pickers
//

#import <UIKit/UIKit.h>

@interface BIDDatePickerViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)buttonPressed;

@end
