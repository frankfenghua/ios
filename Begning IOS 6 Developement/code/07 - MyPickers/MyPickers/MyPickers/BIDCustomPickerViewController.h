//
//  BIDCustomPickerViewController.h
//  Pickers
//

#import <UIKit/UIKit.h>

@interface BIDCustomPickerViewController : UIViewController
<UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) IBOutlet UILabel *winLabel;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) IBOutlet UIButton *button;

- (IBAction)spin;

@end
