//
//  MYBIDSwitchViewController.h
//  My View Swicher
//
//  Created by fenghua on 2013-08-20.
//  Copyright (c) 2013 ClassroomM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MYBIDYellowViewController;
@class MYBIDBlueViewController;

@interface MYBIDSwitchViewController : UIViewController
@property (strong, nonatomic) MYBIDYellowViewController *yellowViewController;
@property (strong, nonatomic) MYBIDBlueViewController *blueViewController;

- (IBAction)switchViews:(id)sender;
@end
