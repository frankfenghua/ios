//
//  MasterViewController.h
//  MyTableViewExample
//
//  Created by fenghua on 2013-08-12.
//  Copyright (c) 2013 fenghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
