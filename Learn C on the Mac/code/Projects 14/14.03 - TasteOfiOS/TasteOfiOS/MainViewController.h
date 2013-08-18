//
//  MainViewController.h
//  TasteOfiOS
//
//  Created by James Bucanek and David Mark on 11/4/12.
//  Copyright (c) 2012 Apress, Inc. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

- (IBAction)showInfo:(id)sender;

@end
