//
//  DebuggingExampleAppDelegate.h
//  DebuggingExample
//
//  Created by Steven F Daniel on 23/01/11.
//  Copyright 2011 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DebuggingExampleViewController;

@interface DebuggingExampleAppDelegate : NSObject <UIApplicationDelegate> {
@private

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet DebuggingExampleViewController *viewController;

@end
