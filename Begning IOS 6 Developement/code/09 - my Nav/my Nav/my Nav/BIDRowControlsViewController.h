//
//  BIDRowControlsViewController.h
//  my Nav
//
//  Created by fenghua on 2013-08-22.
//  Copyright (c) 2013 ClassroomM. All rights reserved.
//

#import "BIDSecondLevelViewController.h"

@interface BIDRowControlsViewController : BIDSecondLevelViewController
@property (copy, nonatomic) NSArray *characters;
- (IBAction)tappedButton:(UIButton *)sender;
@end
