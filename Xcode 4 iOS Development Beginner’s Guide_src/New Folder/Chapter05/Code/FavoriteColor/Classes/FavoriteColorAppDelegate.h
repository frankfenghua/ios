//
//  FavoriteColorAppDelegate.h
//  FavoriteColor
//
//  Created by GENIESOFT-MACBOOK on 19/12/10.
//  Copyright 2010 GENIESOFT STUDIOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FavoriteColorViewController;

@interface FavoriteColorAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    FavoriteColorViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet FavoriteColorViewController *viewController;

@end
