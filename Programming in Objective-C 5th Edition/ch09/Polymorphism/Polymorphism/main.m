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
        //Dynamic Binding and the id Type
        id dataValue;
        
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
        
        dataValue = f1;
        [dataValue print];
        
        //no compile error, only runtime error
        //[dataValue setReal: 10.0 andImaginary: 2.5];
        
        
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
        
        // now dataValue gets a complex number
        dataValue = c1;
        [dataValue print];
        
    }
    return 0;
}

/*
 The variable dataValue is declared as an id object type. Therefore, dataValue can be used to hold any type of object in the program.Note that no asterisk is used in the declaration line:
 id dataValue;
 
 Objective-C system always keeps track of the class to which an object belongs. It also lies in the concepts of dynamic typing and dynamic binding. That is, the system makes the decision about the class of the object, and, t herefore, which met hod t o invoke dynamically, at runt ime rat her t han at compile t ime
 
 You cannot use t he dot operat or wit h id variables; t he compiler gives you an error if you attempt to do so.
 
 ￼To generate a class object from a class name or another object, you send it the class message. So t o get a class object from a class named Square, you writ e t he following:
 [Square class]
 If mySquare is an instance of Square object,you get its class by writing this:
 [mySquare class]
 To see whether the objects stored in the variables obj1 and obj2 are instances from the same
 class, you writ e t his:
 if ([obj1 class] == [obj2 class])
 
 To see if t he variable myFract is a Fraction class object , you t est t he result from t he expression,
 like this:
 [myFract isMemberOfClass: [Fraction class]]
*/