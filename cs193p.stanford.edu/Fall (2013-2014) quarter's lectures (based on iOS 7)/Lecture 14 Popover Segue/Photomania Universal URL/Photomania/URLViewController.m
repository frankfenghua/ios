//
//  URLViewController.m
//  Photomania
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "URLViewController.h"

@interface URLViewController ()
@property (weak, nonatomic) IBOutlet UITextView *urlTextView;
@end

@implementation URLViewController

- (void)setUrl:(NSURL *)url
{
    _url = url;
    [self updateUI];
}

- (void)viewDidLoad // updateUI here in case our url property was set before outlets loaded
{
    [super viewDidLoad];
    [self updateUI];
}

- (void)updateUI
{
    self.urlTextView.text = [self.url absoluteString];
}

@end
