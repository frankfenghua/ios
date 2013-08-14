//
//  BIDSingleComponentPickerViewController.h
//  Pickers
//

#import <UIKit/UIKit.h>

@interface BIDSingleComponentPickerViewController : UIViewController
<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIPickerView *singlePicker;
@property (strong, nonatomic) NSArray *characterNames;
- (IBAction)buttonPressed;

@end
