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
        
        
        //test
        ClassA *a2 = [[ClassA alloc] init];
        ClassB *b2 = [[ClassB alloc] init];
        
        [a2 initVar];
        [a2 printVar];// reveal value of x;
        
        [b2 initVar]; // use overriding ClassB method
        [b2 printVar]; // reveal value of x;
        
        return 0;
        
    }
    return 0;
}

