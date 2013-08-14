//
//  BIDDependentComponentPickerViewController.h
//  Pickers
//

#import <UIKit/UIKit.h>

#define kStateComponent 0
#define kZipComponent   1

@interface BIDDependentComponentPickerViewController : UIViewController
<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIPickerView *dependentPicker;
@property (strong, nonatomic) NSDictionary *stateZips;
@property (strong, nonatomic) NSArray *states;
@property (strong, nonatomic) NSArray *zips;

- (IBAction) buttonPressed;

@end
