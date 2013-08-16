//
//  main.m
//  prog4
//
//  Created by fenghua on 2013-08-15.
//  Copyright (c) 2013 fenghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fraction.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        Fraction *myFraction = [[Fraction alloc] init];
        
        // set fraction to 1/3
        [myFraction setNumerator: 1];
        [myFraction setDenominator: 3];
        
        // display the fraction
        NSLog (@"The value of myFraction is:");
        [myFraction print];
        
    }
    return 0;
}

