//
//  BIDRowControlsViewController.h
//  Nav
//

#import "BIDSecondLevelViewController.h"

@interface BIDRowControlsViewController : BIDSecondLevelViewController

@property (copy, nonatomic) NSArray *characters;
- (IBAction)tappedButton:(UIButton *)sender;

@end
