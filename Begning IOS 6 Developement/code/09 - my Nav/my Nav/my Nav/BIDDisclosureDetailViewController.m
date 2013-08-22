//
//  BIDDisclosureDetailViewController.m
//  my Nav
//
//  Created by fenghua on 2013-08-21.
//  Copyright (c) 2013 ClassroomM. All rights reserved.
//

#import "BIDDisclosureDetailViewController.h"


@implementation BIDDisclosureDetailViewController

- (UILabel *)label;
{
    return (id)self.view;
}

- (void)loadView;
{
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    self.view = label;
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    self.label.text = self.message;
}

@end
