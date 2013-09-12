//
//  Sample_05AppDelegate.h
//  Sample 05
//
//  Created by Lucas Jordan on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Example01Controller.h"
#import "Example02Controller.h"
#import "Example03Controller.h"

@interface Sample_05AppDelegate : NSObject <UIApplicationDelegate> {

    IBOutlet UINavigationController *navigationController;
    IBOutlet Example01Controller *example01Controller;
    IBOutlet Example02Controller *example02Controller;
    IBOutlet Example03Controller *example03Controller;
    
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
- (IBAction)example01ButtonClicked:(id)sender;
- (IBAction)example02ButtonClicked:(id)sender;
- (IBAction)example03ButtonClicked:(id)sender;

@end
