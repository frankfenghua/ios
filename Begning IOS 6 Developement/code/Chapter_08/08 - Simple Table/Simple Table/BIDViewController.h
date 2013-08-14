//
//  BIDViewController.h
//  Simple Table
//

#import <UIKit/UIKit.h>

@interface BIDViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>

@property (copy, nonatomic) NSArray *dwarves;

@end
