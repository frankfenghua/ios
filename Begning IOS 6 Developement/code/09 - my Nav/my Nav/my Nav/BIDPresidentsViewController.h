//
//  BIDPresidentsViewController.h
//  my Nav
//
//  Created by fenghua on 2013-08-22.
//  Copyright (c) 2013 ClassroomM. All rights reserved.
//

#import "BIDSecondLevelViewController.h"
#import "BIDPresidentDetailViewController.h"

@interface BIDPresidentsViewController : BIDSecondLevelViewController<BIDPresidentDetailViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *presidents;


@end
