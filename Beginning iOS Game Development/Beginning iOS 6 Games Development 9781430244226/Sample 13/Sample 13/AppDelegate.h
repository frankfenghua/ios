//
//  AppDelegate.h
//  Sample 13
//
//  Created by Lucas Jordan on 8/13/12.
//  Copyright (c) 2012 Lucas Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhysicsViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PhysicsViewController *viewController;

- (void)startSimulation;

@end
