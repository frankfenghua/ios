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

/*
 Abstract Classes
 What better way to conclude this chapter than with a bit of terminology? We introduce it here because it’s directly related to the notion of inheritance.
 Somet imes, classes are creat ed just t o make it easier for someone t o creat e a subclass. For that reason, these classes are called abstract classes or, equivalently, abstract superclasses. Methods and instance variables are defined in the class, but no one is expected to actually creat e an inst ance from t hat class. For example, consider t he root object NSObject. Can you t hink of any use for defining an object from that class?
*/