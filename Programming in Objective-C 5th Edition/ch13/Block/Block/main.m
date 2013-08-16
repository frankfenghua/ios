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
        
        //from book
        int foo = 10;
        void (^printFoo)(void) = ^(void) {
            NSLog (@"foo = %i", foo);
            //foo = 20; // ** THIS LINE GENERATES A COMPILER ERROR
        };
            foo = 15;
            printFoo ();
            NSLog (@"foo = %i", foo);
        
    }
    return 0;
}

/*
 http://rypress.com/tutorials/objective-c/blocks.html
 The fact that they can be defined inline makes it easy to use them inside of method calls, and since they are closures, it’s possible to capture the value of surrounding variables with literally no additional effort.
 
 A block is identified by a leading caret (^) character. It’s followed by the parenthesized argument list that the block takes. In our case, our block takes no arguments, so we write void just as we did in the function definition.
 You can assign this block to a variable called printMessage, as long as the variable is properly declared (and here’s where the syntax gets tough):
 void (^printMessage)(void) = ^(void){
 NSLog (@"Programming is fun."); };
 To the left of the equal sign we specify that printMessage is a pointer to a block that takes no arguments and returns no value. Note that the assignment statement is terminated by a semicolon.
 Executing a block referenced by a variable is done the same way a function is called:
 printMessage ();
*/