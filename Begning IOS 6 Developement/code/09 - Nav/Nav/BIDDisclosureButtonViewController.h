//
//  BIDDisclosureButtonViewController.h
//  Nav
//

#import "BIDSecondLevelViewController.h"

@class BIDDisclosureDetailViewController;

@interface BIDDisclosureButtonViewController : BIDSecondLevelViewController

@property (copy, nonatomic) NSArray *movies;
@property (strong, nonatomic) BIDDisclosureDetailViewController *detailController;

@end
