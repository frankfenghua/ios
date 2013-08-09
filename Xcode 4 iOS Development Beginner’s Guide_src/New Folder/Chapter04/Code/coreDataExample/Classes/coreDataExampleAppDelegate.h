//
//  coreDataExampleAppDelegate.h
//  coreDataExample
//
//  Created by Steven F Daniel on 5/12/10.
//  Copyright 2010 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class coreDataViewController;

@interface coreDataExampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    coreDataViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet coreDataViewController *viewController;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;

@end
