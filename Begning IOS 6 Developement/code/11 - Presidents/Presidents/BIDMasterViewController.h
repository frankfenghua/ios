//
//  BIDMasterViewController.h
//  Presidents
//

#import <UIKit/UIKit.h>

@class BIDDetailViewController;

@interface BIDMasterViewController : UITableViewController

@property (strong, nonatomic) BIDDetailViewController *detailViewController;
@property (copy, nonatomic) NSArray *presidents;

@end
