//
//  PizzaOrdersViewController.h
//  PizzaOrders
//
//  Created by Steven F Daniel on 28/05/11.
//  Copyright 2011 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PizzaOrdersViewController : UIViewController {
	
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

@property (nonatomic, retain) IBOutlet UISwitch *toppingTomato;
@property (nonatomic, retain) IBOutlet UISwitch *toppingOnion;
@property (nonatomic, retain) IBOutlet UISwitch *toppingCapsicum;
@property (nonatomic, retain) IBOutlet UISwitch *toppingOlives;
@property (nonatomic, retain) IBOutlet UISwitch *toppingSalami;
@property (nonatomic, retain) IBOutlet UISwitch *toppingMozarella;
@property (nonatomic, retain) IBOutlet UISwitch *crustThin;
@property (nonatomic, retain) IBOutlet UISwitch *crustThick;
@property (nonatomic, retain) IBOutlet UISwitch *crustCheeseFilled;

@property (nonatomic, retain) IBOutlet UITextField *TotalPayment;
@property (nonatomic, retain) IBOutlet UIButton *Calculate;

@end
