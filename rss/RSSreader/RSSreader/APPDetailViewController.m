//
//  APPDetailViewController.m
//  RSSreader
//
//  Created by feng on 2014-05-04.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "APPDetailViewController.h"
#import <MessageUI/MessageUI.h>

@implementation APPDetailViewController

#pragma mark - Managing the detail item

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *myURL = [NSURL URLWithString: [self.url stringByAddingPercentEscapesUsingEncoding:
                                          NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    [self.webView loadRequest:request];
}

- (IBAction)sendEmail:(id)sender {
    // Email Subject
    NSString *emailTitle = self.feedTitle;
    // Email Content
    NSString *messageBody = [NSString stringWithFormat:NSLocalizedString(@"MESSAGE_BODY", @""), self.url,self.url]; // Change the message body to HTML
    
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"frankfenghua@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:YES];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendSMS:(id)sender {
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", @"") message:NSLocalizedString(@"NO_SMS_SUPPORT", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"CANCEL_BUTTON",@"") otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = @[@"5144633785", @"5142617892"];
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"SMS_MESSAGE", @""), self.url];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (IBAction)saveFeed:(id)sender {
    NSLog(@"description = %@",self.description);
    NSString *savestring = self.description;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:savestring forKey:@"savedstring"];
    [defaults synchronize];

}

- (IBAction)loadFeed:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *loadstring = [defaults objectForKey:@"savedstring"];

    NSLog(@"loadstring = %@",loadstring);

    self.webView.hidden = YES;
    [self.textView setText:loadstring];

}
@end
		