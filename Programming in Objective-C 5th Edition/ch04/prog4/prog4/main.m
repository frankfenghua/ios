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
        
        //dot operator
        myFraction.numerator= 5;
        myFraction.denominator=6;
        
        // display the fraction
        NSLog (@"The value of myFraction is:");
        [myFraction print];
        
        //Multiple Arguments to Methods
        [myFraction setTo: 100 over: 200];
        [myFraction print];
        
        [myFraction setTo: 1 over: 3];
        [myFraction print];
    }
    return 0;
}

/*
 In Program 7.1, you set t he numerat or and denominat or of your fract ion t o 1/3 using t he following two lines of code:
 [myFraction setNumerator: 1];
 [myFraction setDenominator: 3];
 Here’s an equivalent way to write the same two lines:
 myFraction.numerator = 1;
 myFraction.denominator = 3;
 We use these new features for synthesizing methods and accessing properties throughout the remainder of this text.
*/

/*
Based on the preceding discussion, realize that although it’s syntactically correct t o writ e a st at ement such as myFraction.print, it ’s not considered good programming style. The dot operator was really intended to be used with properties; typically to set/get the value of an instance variable. Methods that do work (such as calculating the sum of two fractions) are labeled as tasks in Apple documentation. Tasks are typically not executed using the dot operator; the traditional bracketed message expression is the preferred synt ax.
*/