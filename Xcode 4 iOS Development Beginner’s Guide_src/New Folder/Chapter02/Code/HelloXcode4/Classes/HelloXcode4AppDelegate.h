//
//  HelloXcode4AppDelegate.h
//  HelloXcode4
//
//  Created by Steven F Daniel on 31/10/10.
//  Copyright (c) 2010 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HelloXcode4ViewController;

@interface HelloXcode4AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    
    HelloXcode4ViewController *viewController;
    UISegmentedControl *Select;
    UITextField *HelloText;
    UILabel *enteredname;
}
@property (nonatomic, retain) IBOutlet UITextField *HelloText;
@property (nonatomic, retain) IBOutlet UILabel *enteredname;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) HelloXcode4ViewController *viewController;

@end
