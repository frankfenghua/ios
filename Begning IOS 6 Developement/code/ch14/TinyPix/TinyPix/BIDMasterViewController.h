//
//  BIDMasterViewController.h
//  TinyPix
//

#import <UIKit/UIKit.h>

@interface BIDMasterViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *colorControl;
- (IBAction)chooseColor:(id)sender;

@end
