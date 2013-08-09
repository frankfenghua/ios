//
//  DatePickersExampleViewController.h
//  DatePickersExample
//
//  Created by Steven F Daniel on 21/12/10.
//  Copyright 2010 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickersExampleViewController : UIViewController {
    UIDatePicker *theDate;
    UILabel *ourLabel;
}
@property (nonatomic, retain) IBOutlet UIDatePicker *theDate;
@property (nonatomic, retain) IBOutlet UILabel *ourLabel;

@end