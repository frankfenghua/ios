//
//  SwitchesSlidersSegmentsViewController.h
//  SwitchesSlidersSegments
//
//  Created by Steven F Daniel on 20/12/10.
//  Copyright 2010 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchesSlidersSegmentsViewController : UIViewController {

    IBOutlet UISegmentedControl *colorChoice;
    IBOutlet UISwitch *toggleSwitch;
    IBOutlet UIWebView *ourWebView;
    IBOutlet UILabel *toggleValue;
    IBOutlet UILabel *chosenColor;
    IBOutlet UILabel *sliderValue;
    IBOutlet UISlider *ourSlider;
}
@property (nonatomic, retain) IBOutlet UILabel *sliderValue;
@property (nonatomic, retain) IBOutlet UISlider *ourSlider;
@property (nonatomic, retain) IBOutlet UISegmentedControl *colorChoice;
@property (nonatomic, retain) IBOutlet UISwitch *toggleSwitch;
@property (nonatomic, retain) IBOutlet UILabel *toggleValue;
@property (nonatomic, retain) IBOutlet UILabel *chosenColor;

@end
