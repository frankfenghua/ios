//
//  PhotographersCDTVC.h
//  Photomania
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "CoreDataTableViewController.h"

// will segue to a PhotosByPhotographerCDTVC
// use @"Photographer Cell" as your cells' reuse identifer

@interface PhotographersCDTVC : CoreDataTableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
