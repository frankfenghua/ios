//
//  TextViewsandButtonsAppDelegate.h
//  TextViewsandButtons
//
//  Created by GENIESOFT-MACBOOK on 19/12/10.
//  Copyright 2010 GENIESOFT STUDIOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextViewsandButtonsViewController;

@interface TextViewsandButtonsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TextViewsandButtonsViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet TextViewsandButtonsViewController *viewController;

@end
