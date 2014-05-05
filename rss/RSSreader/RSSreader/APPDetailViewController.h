//
//  APPDetailViewController.h
//  RSSreader
//
//  Created by feng on 2014-05-04.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APPDetailViewController : UIViewController

@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *feedTitle;
@property (copy, nonatomic) NSString *description;

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UITextView *textView;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *emailButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *smsButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *loadButton;

- (IBAction)sendEmail:(id)sender;
- (IBAction)sendSMS:(id)sender;
- (IBAction)saveFeed:(id)sender;
- (IBAction)loadFeed:(id)sender;


@end
