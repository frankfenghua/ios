//
//  ViewController.h
//  MyPizzaOrders
//
//  Created by fenghua on 2013-08-12.
//  Copyright (c) 2013 fenghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    
    IBOutlet UISwitch *toppingTomato;
    IBOutlet UISwitch *toppingOnion;
    IBOutlet UISwitch *toppingCapsicum;
    IBOutlet UISwitch *toppingOlives;
    IBOutlet UISwitch *toppingSalami;
    IBOutlet UISwitch *toppingMozarella;
    IBOutlet UISwitch *crustThin;
    IBOutlet UISwitch *crustThick;
    IBOutlet UISwitch *crustCheeseFilled;
    IBOutlet UITextField *TotalPayment;
    IBOutlet UIButton *Calculate;
}

@property (retain, nonatomic) IBOutlet UISwitch *toppingTomato;
@property (retain, nonatomic) IBOutlet UISwitch *toppingOnion;
@property (retain, nonatomic) IBOutlet UISwitch *toppingCapsicum;
@property (retain, nonatomic) IBOutlet UISwitch *toppingOlives;
@property (retain, nonatomic) IBOutlet UISwitch *toppingSalami;
@property (retain, nonatomic) IBOutlet UISwitch *toppingMozarella;
@property (retain, nonatomic) IBOutlet UISwitch *crustThin;
@property (retain, nonatomic) IBOutlet UISwitch *crustThick;
@property (retain, nonatomic) IBOutlet UISwitch *crustCheeseFilled;
@property (retain, nonatomic) IBOutlet UITextField *TotalPayment;
@property (retain, nonatomic) IBOutlet UIButton *Calculate;

@end
