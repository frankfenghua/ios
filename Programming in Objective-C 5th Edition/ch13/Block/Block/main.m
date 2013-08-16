//
//  main.m
//  Block
//
//  Created by fenghua on 2013-08-16.
//  Copyright (c) 2013 fenghua. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // Declare the block variable
        double (^distanceFromRateAndTime)(double rate, double time);
        
        // Create and assign the block
        distanceFromRateAndTime = ^double(double rate, double time) {
            return rate * time;
        };
        // Call the block
        double dx = distanceFromRateAndTime(35, 1.5);
        
        NSLog(@"A car driving 35 mph will travel "
              @"%.2f miles in 1.5 hours.", dx);
        
        NSString *make = @"Honda";
        NSString *(^getFullCarName)(NSString *) = ^(NSString *model) {
            return [make stringByAppendingFormat:@" %@", model];
        };
        NSLog(@"%@", getFullCarName(@"Accord"));    // Honda Accord
        
        // Try changing the non-local variable (it won't change the block)
        make = @"Porsche";
        NSLog(@"%@", getFullCarName(@"911 Turbo")); // Honda 911 Turbo
        
    }
    return 0;
}

/*
 http://rypress.com/tutorials/objective-c/blocks.html
 The fact that they can be defined inline makes it easy to use them inside of method calls, and since they are closures, it’s possible to capture the value of surrounding variables with literally no additional effort.
*/