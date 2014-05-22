//
//  URLViewController.h
//  Photomania
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface URLViewController : UIViewController

// displays the url
// it is not a popover-specific class in any way
// it would work in any environment
// (e.g. pushed in a navigation controller would work)

@property (nonatomic, strong) NSURL *url;

@end
