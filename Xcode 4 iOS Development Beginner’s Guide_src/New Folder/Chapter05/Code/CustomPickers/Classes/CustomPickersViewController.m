//
//  CustomPickersViewController.m
//  CustomPickers
//
//  Created by Steven F Daniel on 21/12/10.
//  Copyright 2010 GenieSoft Studios. All rights reserved.
//

#import "CustomPickersViewController.h"

@implementation CustomPickersViewController
@synthesize matchResult;


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 2; // determines how many sections our picker will be using.
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if (component == 0) {
		return [animalType count];
	} else {
		return [animalNoise count];
	}
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
		return [animalType objectAtIndex:row];
	} else {
		return [animalNoise objectAtIndex:row]; 
	}
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
	NSString *matchType;
    
	int selectedType;
	int selectedNoise;
	int matchedNoise;
	
	selectedType=[pickerView selectedRowInComponent:0];
	selectedNoise=[pickerView selectedRowInComponent:1];
	
	matchedNoise=([animalNoise count]-1)-[pickerView selectedRowInComponent:1];
	
	if (selectedType == matchedNoise) {
		matchType=[[NSString alloc] initWithFormat:@"You are correct, a %@ does go '%@'!",
                      [animalType objectAtIndex:selectedType],
                      [animalNoise objectAtIndex:selectedNoise]];
	} else {
		matchType=[[NSString alloc] initWithFormat:@"You are incorrect, a %@ does not go '%@'!",
                      [animalType objectAtIndex:selectedType],
                      [animalNoise objectAtIndex:selectedNoise]];
	}
	
	matchResult.text = matchType;
	matchResult.textColor=[UIColor redColor];
    
	[matchType release];
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    animalType=[[NSArray alloc]initWithObjects:@"Dog",@"Cat",@"Pig",@"Mouse",@"Snake",nil];
	animalNoise=[[NSArray alloc]initWithObjects:@"Sssss",@"Squeak",@"Oink",@"Meow",@"Woof",nil];			  
    [super viewDidLoad];
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [animalType release];
    [animalNoise release];
    [super dealloc];
}

@end
