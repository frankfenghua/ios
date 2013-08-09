//
//  coreDataViewController.m
//  coreData
//
//  Created by Steven F Daniel on 5/12/10.
//  Copyright 2010 GenieSoft Studios. All rights reserved.
//

#import "coreDataViewController.h"
#import "coreDataExampleAppDelegate.h"

@implementation coreDataViewController
@synthesize recordsFound, Name, DOB, Gender;

- (IBAction)saveData:(id)sender {
    
    coreDataExampleAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *newContact;
    
    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
    
    [newContact setValue:Name.text forKey:@"name"];
    [newContact setValue:DOB.text forKey:@"dob"];
    [newContact setValue:Gender.text forKey:@"gender"];
    
    Name.text = @"";
    DOB.text = @"";
    Gender.text = @"";
    
    NSError *error;
    [context save:&error];
    
    recordsFound.text = @"Details have been saved to the database.";
}

- (IBAction)searchData:(id)sender {
    
    coreDataExampleAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:entityDesc];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(name = %@)", Name.text];
    [request setPredicate:pred];
    
    NSManagedObject *matches = nil;
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    if ([objects count] == 0) {
        recordsFound.text = @"No matches were found matching your criteria";
    } else {
        matches = [objects objectAtIndex:0];
        DOB.text = [matches valueForKey:@"dob"];
        Gender.text = [matches valueForKey:@"gender"];
        recordsFound.text = [NSString stringWithFormat:@"%d Matches Found", [objects count]];
    }
    [request release];
}

- (IBAction)clearData:(id)sender {
    Name.text=@"";
    DOB.text=@"";
    Gender.text=@"";
    recordsFound.text=@"";
}


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
recordsFound.text=@"";
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.Name = nil;
    self.DOB = nil;
    self.Gender = nil;
    self.recordsFound = nil;
}


- (void)dealloc {
    [Name release];
    [DOB release];
    [Gender release];
    [recordsFound release];
    [super dealloc];
}


@end
