//
//  DetailViewController.h
//  MyTableViewExample
//
//  Created by fenghua on 2013-08-12.
//  Copyright (c) 2013 fenghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
