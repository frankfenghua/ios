//
//  BIDDisclosureButtonViewController.h
//  my Nav
//
//  Created by fenghua on 2013-08-21.
//  Copyright (c) 2013 ClassroomM. All rights reserved.
//

#import "BIDSecondLevelViewController.h"
@class BIDDisclosureDetailViewController;

@interface BIDDisclosureButtonViewController : BIDSecondLevelViewController
@property (copy, nonatomic) NSArray *movies;
@property (strong, nonatomic) BIDDisclosureDetailViewController *detailController;
@end
