//
//  HelloXcode4_GUIAppDelegate.h
//  HelloXcode4_GUI
//
//  Created by Steven F Daniel on 13/11/10.
//  Copyright (c) 2010 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HelloXcode4_GUIViewController;

@interface HelloXcode4_GUIAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    HelloXcode4_GUIViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet HelloXcode4_GUIViewController *viewController;

@end
