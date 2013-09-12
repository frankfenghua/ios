//
//  Sample_03AppDelegate.h
//  Sample 03
//
//  Created by Lucas Jordan on 4/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameController.h"

@interface Sample_03AppDelegate : NSObject <UIApplicationDelegate> {
    IBOutlet GameController* gameController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

-(NSString*)gameArchivePath;

@end
