//
//  main.m
//  Inheritance
//
//  Created by fenghua on 2013-08-16.
//  Copyright (c) 2013 fenghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassA.h"
#import "ClassB.h"


int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        ClassB *b = [[ClassB alloc] init];
        
        [b initVar]; // will use inherited method
        [b printVar];// reveal value of x;
        return 0;
        
    }
    return 0;
}

