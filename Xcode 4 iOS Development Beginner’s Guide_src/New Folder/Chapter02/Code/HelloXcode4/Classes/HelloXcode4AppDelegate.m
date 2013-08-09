//
//  HelloXcode4AppDelegate.m
//  HelloXcode4
//
//  Created by Steven F Daniel on 31/10/10.
//  Copyright (c) 2010 GenieSoft Studios. All rights reserved.
//

#import "HelloXcode4AppDelegate.h"
#import "HelloXcode4ViewController.h"

@implementation HelloXcode4AppDelegate


@synthesize HelloText;
@synthesize enteredname;
@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions { 
    
    // allocate the memory for our view controller
    self.viewController = [HelloXcode4ViewController alloc];
    
    // now, we need to add our view controller to the window
    [window addSubview:self.viewController.view];
    
    // Override point for customization after application launch.
    [window makeKeyAndVisible];
    return YES;
}
- (IBAction)ClickMe:(id)sender {
     NSLog(@"Hello World");
    enteredname.text=HelloText.text;
    enteredname.textColor=[UIColor blueColor];
}

- (void)dealloc {
    [viewController release];
    [window release];
    [Select release];
    [HelloText release];
    [enteredname release];
    [super dealloc];
}@end
