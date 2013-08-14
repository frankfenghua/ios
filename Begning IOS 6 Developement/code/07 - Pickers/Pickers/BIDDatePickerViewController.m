//
//  BIDDatePickerViewController.m
//  Pickers
//

#import "BIDDatePickerViewController.h"

@implementation BIDDatePickerViewController

- (IBAction)buttonPressed
{
    NSDate *selected = [self.datePicker date];
    NSString *message = [[NSString alloc] initWithFormat:
                         @"The date and time you selected is: %@", selected];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Date and Time Selected"
                          message:message
                          delegate:nil
                          cancelButtonTitle:@"Yes, I did."
                          otherButtonTitles:nil];
    [alert show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDate *now = [NSDate date];
    [self.datePicker setDate:now animated:NO];
}

@end
