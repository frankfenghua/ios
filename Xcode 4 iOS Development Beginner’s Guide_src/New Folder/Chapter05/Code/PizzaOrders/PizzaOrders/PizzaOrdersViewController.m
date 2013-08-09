//
//  PizzaOrdersViewController.m
//  PizzaOrders
//
//  Created by Steven F Daniel on 28/05/11.
//  Copyright 2011 GenieSoft Studios. All rights reserved.
//

#import "PizzaOrdersViewController.h"

@implementation PizzaOrdersViewController
@synthesize Calculate;
@synthesize TotalPayment;
@synthesize toppingTomato,toppingOnion,toppingCapsicum,toppingOlives,toppingSalami,toppingMozarella,crustThin,crustThick,crustCheeseFilled;

- (void)dealloc
{
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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/
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
	
	// Check to see if we have chosen to include Tomatoes on our Pizza 
	if ([toppingTomato isOn]){
		   tomatoAmount = 0.50; 
	}
	else { tomatoAmount = 0; }
	
	// Check to see if we have chosen to include Onions on our Pizza 
	if ([toppingOnion isOn]){
		   onionAmount = 0.80;
	}
	else { onionAmount = 0; }
	
	// Check to see if we have chosen to include Capsicum on our Pizza 
	if ([toppingCapsicum isOn]){
		   capsicumAmount = 0.80;
	}
	else { capsicumAmount = 0; }
	
	// Check to see if we have chosen to include Olives on our Pizza 
	if ([toppingOlives isOn]){
	  	   oliveAmount = 0.80;
	}
	else { oliveAmount = 0; }
	
	// Check to see if we have chosen to include Salami on our Pizza 
	if ([toppingSalami isOn]){
		   salamiAmount = 0.80;
	}
	else { salamiAmount = 0; }
	
	// Check to see if we have chosen to include Mozarella on our Pizza 
	if ([toppingMozarella isOn]){
		   mozarellaAmount = 0.80;
	}
	else { mozarellaAmount = 0; }
	
	// Check to see if we have specified to have a Thin Crust Pizza.
	if ([crustThin isOn]){
		   thinCrustAmount = 2.00;
	}
	else { thinCrustAmount = 0; }
	
	// Check to see if we have specified to have a Thick Crust Pizza.
	if ([crustThick isOn]){
		   thickCrustAmount = 2.50;
	}
	else { thickCrustAmount = 0; }
	
	// Check to see if we have specified to have a Cheese Filled Crust Pizza.
	if ([crustCheeseFilled isOn]){
		   cheeseCrustAmount = 3.00;
	}
	else { cheeseCrustAmount = 0; }
	
	// Calculate our total amount based on what has been chosen
	totalAmount = (tomatoAmount + onionAmount + capsicumAmount+oliveAmount + 
				   salamiAmount + mozarellaAmount + thinCrustAmount + 
				   thickCrustAmount + cheeseCrustAmount);
	
	// Output the total amount to the screen.
	TotalPayment.text = [[NSString alloc] initWithFormat:@"%5.2f",totalAmount];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
