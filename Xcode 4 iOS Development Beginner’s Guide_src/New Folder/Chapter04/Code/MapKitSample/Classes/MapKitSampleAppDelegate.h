//
//  MapKitSampleAppDelegate.h
//  MapKitSample
//
//  Created by Steven F Daniel on 3/12/10.
//  Copyright 2010 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapKitSampleViewController;

@interface MapKitSampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MapKitSampleViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet MapKitSampleViewController *viewController;

@end
