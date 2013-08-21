//
//  main.m
//  MyPickers
//
//  Created by fenghua on 2013-08-20.
//  Copyright (c) 2013 fenghua. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BIDAppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        @try{
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([BIDAppDelegate class]));
        }
        @catch (NSException* exception) {
            NSLog(@"Uncaught exception: %@", exception.description);
            NSLog(@"Statck trace: %@", [exception callStackSymbols
                                        ]);
        }
    }
}
