//
//  PizzaOrdersAppDelegate.h
//  PizzaOrders
//
//  Created by Steven F Daniel on 28/05/11.
//  Copyright 2011 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PizzaOrdersViewController;

@interface PizzaOrdersAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet PizzaOrdersViewController *viewController;

@end
