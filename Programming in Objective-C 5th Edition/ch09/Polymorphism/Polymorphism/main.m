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
        
        //ask questions of Class
        Complex *myComplex = [[Complex alloc] init];
        // isMemberOf:
        if ( [myComplex isMemberOfClass: [Complex class]] == YES ) NSLog (@"myComplex is a member of Complex class");
        if ( [myComplex isMemberOfClass: [Fraction class]] == YES ) NSLog (@"myComplex is a member of Fraction class");
        if ( [myComplex isMemberOfClass: [NSObject class]] == YES ) NSLog (@"myComplex is a member of NSObject class");
        // isKindOf:
        if ( [myComplex isKindOfClass: [Complex class]] == YES ) NSLog (@"myComplex is a kind of Complex");
        /*
        ￼￼￼￼￼The respondsToSelector: method is used extensively in iOS for implementing the concept of delegation. As you’ll learn in Chapter 10, “More on Variables and Data Types,” the system often gives you the option to implement one or more methods in your class to handle certain events or provide certain information (such as the number of sections in a table). For the system to det ermine whet her you have in fact implement ed a part icular met hod, it uses respondsToSelector: to see whether it can delegate the handling of the event to your method. If you didn’t implement the method, it takes care of the event it self, doing what ever is defined as t he default behavior.
         */
        if ( [myComplex isKindOfClass: [Fraction class]] == YES )  NSLog (@"myComplex is a kind of Fraction");
        if ( [myComplex isKindOfClass: [NSObject class]] == YES ) NSLog (@"myComplex is a kind of NSObject");
        // respondsTo:
        if ( [myComplex respondsToSelector: @selector (print:)] == YES ) NSLog (@"myComplex responds to print: method");
        if ( [myComplex respondsToSelector: @selector (setReal:andImaginary:)] == YES ) NSLog (@"myComplex responds to setReal:andImaginary: method");
        if ( [Complex respondsToSelector: @selector (alloc)] == YES ) NSLog (@"Complex class responds to alloc method");
        // instancesRespondTo:
        if ([Fraction instancesRespondToSelector: @selector (convertToNum:)	] == YES) NSLog (@"Instances of Fraction respond to convertToNum: method");
        if ([Complex instancesRespondToSelector: @selector (add:)] == YES) NSLog (@"Instances of Complex respond to add: method");
        if ([Complex isSubclassOfClass: [Fraction class]] == YES) NSLog (@"Complex is a subclass of a Fraction");
    }
    return 0;
}

/*
 The variable dataValue is declared as an id object type. Therefore, dataValue can be used to hold any type of object in the program.Note that no asterisk is used in the declaration line:
 id dataValue;
 
 Objective-C system always keeps track of the class to which an object belongs. It also lies in the concepts of dynamic typing and dynamic binding. That is, the system makes the decision about the class of the object, and, t herefore, which met hod t o invoke dynamically, at runt ime rat her t han at compile t ime
 
 You cannot use t he dot operat or wit h id variables; t he compiler gives you an error if you attempt to do so.
 
 ￼To generate a class object from a class name or another object, you send it the class message. So t o get a class object from a class named Complex, you writ e t he following:
 [Complex class]
 If myComplex is an instance of Complex object,you get its class by writing this:
 [myComplex class]
 To see whether the objects stored in the variables obj1 and obj2 are instances from the same
 class, you writ e t his:
 if ([obj1 class] == [obj2 class])
 
 To see if t he variable myFract is a Fraction class object , you t est t he result from t he expression,
 like this:
 [myFract isMemberOfClass: [Fraction class]]
*/