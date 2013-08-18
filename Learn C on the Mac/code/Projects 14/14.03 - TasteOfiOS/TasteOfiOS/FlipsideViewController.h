//
//  FlipsideViewController.h
//  TasteOfiOS
//
//  Created by James Bucanek and David Mark on 11/4/12.
//  Copyright (c) 2012 Apress, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
