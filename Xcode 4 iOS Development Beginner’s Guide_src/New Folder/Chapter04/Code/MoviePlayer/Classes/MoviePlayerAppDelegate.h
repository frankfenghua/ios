//
//  MoviePlayerAppDelegate.h
//  MoviePlayer
//
//  Created by Steven F Daniel on 2/12/10.
//  Copyright 2010 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MoviePlayerViewController;

@interface MoviePlayerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MoviePlayerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet MoviePlayerViewController *viewController;

@end
