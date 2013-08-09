//
//  coreDataViewController.h
//  coreData
//
//  Created by Steven F Daniel on 5/12/10.
//  Copyright 2010 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface coreDataViewController : UIViewController {
    
    IBOutlet UITextField *Name;
    IBOutlet UITextField *DOB;
    IBOutlet UITextField *Gender;
    IBOutlet UILabel *recordsFound;
}
@property (nonatomic, retain) IBOutlet UITextField *Name;
@property (nonatomic, retain) IBOutlet UITextField *DOB;
@property (nonatomic, retain) IBOutlet UITextField *Gender;
@property (nonatomic, retain) IBOutlet UILabel *recordsFound;

-(IBAction)saveData:(id)sender;
-(IBAction)searchData:(id)sender;
-(IBAction)clearData:(id)sender;

@end
