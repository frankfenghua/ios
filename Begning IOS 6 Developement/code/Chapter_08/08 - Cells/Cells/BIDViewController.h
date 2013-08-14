//
//  BIDViewController.h
//  Cells
//

#import <UIKit/UIKit.h>

@interface BIDViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>

@property (copy, nonatomic) NSArray *computers;

@end
