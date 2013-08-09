//
//  GetUsersAttentionAppDelegate.h
//  GetUsersAttention
//
//  Created by Steven F Daniel on 27/12/10.
//  Copyright 2010 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GetUsersAttentionViewController;

@interface GetUsersAttentionAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    GetUsersAttentionViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet GetUsersAttentionViewController *viewController;

@end
