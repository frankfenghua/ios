//
//  BIDSingleComponentPickerViewController.h
//  MyPickers
//
//  Created by fenghua on 2013-08-20.
//  Copyright (c) 2013 fenghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BIDSingleComponentPickerViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UIPickerView *singlePicker;
@property (strong, nonatomic) NSArray *characterNames;
- (IBAction)buttonPressed;
@end
