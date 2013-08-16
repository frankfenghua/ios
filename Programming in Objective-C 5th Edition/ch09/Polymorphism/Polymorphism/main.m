//
//  main.m
//  Polymorphism
//
//  Created by fenghua on 2013-08-16.
//  Copyright (c) 2013 fenghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Complex.h"
#import "Fraction.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        Fraction *f1 = [[Fraction alloc] init];
        Fraction *f2 = [[Fraction alloc] init];
        
        Fraction *fracResult;
        
        [f1 setTo: 1 over: 10];
        [f2 setTo: 2 over: 15];
        
        // add and print 2 fractions
        [f1 print]; NSLog (@" +"); [f2 print];
        NSLog (@"----");
        fracResult = [f1 add: f2];
        [fracResult print];
        
        Complex *compResult;
        
        Complex *c1 = [[Complex alloc] init];
        Complex *c2 = [[Complex alloc] init];
        
        [c1 setReal: 18.0 andImaginary: 2.5];
        [c2 setReal: -5.0 andImaginary: 3.2];
        
        [c1 print];
        NSLog(@"+");
        [c2 print];
        NSLog (@"---------");
        
        compResult = [c1 add: c2];
        [compResult print];
        
        NSLog (@"\n");
        
    }
    return 0;
}

