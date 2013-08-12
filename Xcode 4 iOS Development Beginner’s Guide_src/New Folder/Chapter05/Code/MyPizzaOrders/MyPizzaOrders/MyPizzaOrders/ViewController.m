//
//  ViewController.m
//  MyPizzaOrders
//
//  Created by fenghua on 2013-08-12.
//  Copyright (c) 2013 fenghua. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize Calculate;
@synthesize TotalPayment;
@synthesize toppingCapsicum,toppingMozarella,toppingOlives,toppingOnion,toppingSalami,toppingTomato,crustCheeseFilled,crustThick,crustThin;

- (IBAction)calculatePurchase:(id)sender {
    // Declare and initialise each of our pizza toppings and base types.
    float totalAmount = 0.00;
    float tomatoAmount = 0.00;
    float onionAmount = 0.00;
    float capsicumAmount = 0.00;
    float oliveAmount = 0.00;
    float salamiAmount = 0.00;
    float mozarellaAmount = 0.00;
    float thinCrustAmount = 0.00;
    float thickCrustAmount = 0.00;
    float cheeseCrustAmount = 0.00;
    
    // Handle each of our topping selections
    // Check to see if we have chosen to include Tomatoes on our  Pizza
    if ([toppingTomato isOn]) {
        tomatoAmount = 0.50;
    }else{
        tomatoAmount = 0.0;
    }
    
    if ([toppingOnion isOn]){
        onionAmount = 0.80;
    }
    else { onionAmount = 0; }
    
    if ([toppingCapsicum isOn]){
        capsicumAmount = 0.80;
    }else { capsicumAmount = 0; }
    
    if ([toppingOlives isOn]){
        oliveAmount = 0.80;
    }
    else { oliveAmount = 0; }
    
    if ([toppingSalami isOn]){
        salamiAmount = 0.80;
    }
    else { salamiAmount = 0; }
    
    if ([toppingMozarella isOn]){
        mozarellaAmount = 0.80;
    }
    else { mozarellaAmount = 0; }
    
    if ([crustThin isOn]){
        thinCrustAmount = 2.00;
    }
    else { thinCrustAmount = 0; }
    
    if ([crustThick isOn]){
        thickCrustAmount = 2.50;
    }
    else { thickCrustAmount = 0; }
    
    if ([crustCheeseFilled isOn]){
        cheeseCrustAmount = 3.00;
    }
    else { cheeseCrustAmount = 0; }
    
    // Calculate our total amount based on what has been chosen
    totalAmount = (tomatoAmount + onionAmount +
                   capsicumAmount+oliveAmount +
                   salamiAmount + mozarellaAmount + thinCrustAmount +
                   thickCrustAmount + cheeseCrustAmount);
    // Output the total amount to the screen.
    TotalPayment.text = [[NSString alloc]
                         initWithFormat:@"%5.2f",totalAmount];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [toppingTomato release];
    [toppingOnion release];
    [toppingCapsicum release];
    [toppingOlives release];
    [toppingSalami release];
    [toppingMozarella release];
    [crustThin release];
    [crustThick release];
    [crustCheeseFilled release];
    [TotalPayment release];
    [Calculate release];
    [super dealloc];
}
@end
