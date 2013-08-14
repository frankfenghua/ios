//
//  BIDLanguageListController.h
//  Presidents
//

#import <UIKit/UIKit.h>

@class BIDDetailViewController;

@interface BIDLanguageListController : UITableViewController

@property (weak, nonatomic) BIDDetailViewController *detailViewController;
@property (strong, nonatomic) NSArray *languageNames;
@property (strong, nonatomic) NSArray *languageCodes;

@end
