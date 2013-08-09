//
//  TextViewsandButtonsViewController.h
//  TextViewsandButtons
//
//  Created by GENIESOFT-MACBOOK on 19/12/10.
//  Copyright 2010 GENIESOFT STUDIOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextViewsandButtonsViewController : UIViewController {
    IBOutlet UITextField *txtName;
    IBOutlet UITextField *txtGender;
    IBOutlet UITextField *txtJob;
    IBOutlet UITextView *txtTextView;
}
@property (nonatomic, retain) IBOutlet UITextField *txtGender;
@property (nonatomic, retain) IBOutlet UITextField *txtName;
@property (nonatomic, retain) IBOutlet UITextField *txtJob;
@property (nonatomic, retain) IBOutlet UITextView *txtTextView;

@end
