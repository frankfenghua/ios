//
//  TapExampleAppDelegate.h
//  TapExample
//
//  Created by Steven F. Daniel on 8/01/11.
//  Copyright 2011 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TapExampleViewController;

@interface TapExampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TapExampleViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet TapExampleViewController *viewController;

@end
