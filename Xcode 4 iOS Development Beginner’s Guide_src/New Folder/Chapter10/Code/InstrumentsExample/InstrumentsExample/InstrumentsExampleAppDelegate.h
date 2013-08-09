//
//  InstrumentsExampleAppDelegate.h
//  InstrumentsExample
//
//  Created by Steven F Daniel on 27/02/11.
//  Copyright 2011 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InstrumentsExampleViewController;

@interface InstrumentsExampleAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet InstrumentsExampleViewController *viewController;

@end
