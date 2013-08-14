//
//  BIDPresidentsViewController.h
//  Nav
//

#import "BIDSecondLevelViewController.h"
#import "BIDPresidentDetailViewController.h"

@interface BIDPresidentsViewController : BIDSecondLevelViewController
<BIDPresidentDetailViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *presidents;

@end
