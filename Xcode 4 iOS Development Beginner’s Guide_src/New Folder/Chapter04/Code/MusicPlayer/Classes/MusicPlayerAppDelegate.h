//
//  MusicPlayerAppDelegate.h
//  MusicPlayer
//
//  Created by Steven F Daniel on 1/12/10.
//  Copyright 2010 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MusicPlayerViewController;

@interface MusicPlayerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MusicPlayerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet MusicPlayerViewController *viewController;

@end
