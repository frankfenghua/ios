//
//  BIDViewController.h
//  Sections
//

#import <UIKit/UIKit.h>

@interface BIDViewController : UIViewController
    <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>

@property (copy, nonatomic) NSDictionary *names;
@property (copy, nonatomic) NSArray *keys;

@end
