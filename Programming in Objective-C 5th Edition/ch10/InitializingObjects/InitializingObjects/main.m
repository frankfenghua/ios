//
//  main.m
//  InitializingObjects
//
//  Created by fenghua on 2013-08-16.
//  Copyright (c) 2013 fenghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fraction.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        Fraction *a, *b;
        
       a = [[Fraction alloc] initWith: 1 over: 3];
       b = [[Fraction alloc] initWith: 3 over: 7];
        
       [a print];
       [b print];
    }
    return 0;
}

