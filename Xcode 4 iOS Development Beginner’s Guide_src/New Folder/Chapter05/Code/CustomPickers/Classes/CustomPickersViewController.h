//
//  CustomPickersViewController.h
//  CustomPickers
//
//  Created by Steven F Daniel on 21/12/10.
//  Copyright 2010 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPickersViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    NSArray *animalType;
    NSArray *animalNoise;
    UILabel *matchResult;
}
@property (nonatomic, retain) IBOutlet UILabel *matchResult;

@end

