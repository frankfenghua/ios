//
//  Fraction.m
//  InitializingObjects
//
//  Created by fenghua on 2013-08-16.
//  Copyright (c) 2013 fenghua. All rights reserved.
//

#import "Fraction.h"

@implementation Fraction
@synthesize numerator;
@synthesize denominator;

-(id)init{
//    self = [super init];
//    if (self != nil) {
//        [self setTo:10 over:25];
//    }
//    return self;
    return [self initWith: 0 over: 0];
}

-(Fraction *) initWith: (int) n over: (int) d {
    self = [super init];
    if (self)
        [self setTo: n over: d];
    return self;
}

-(void) print {
    NSLog (@"%i/%i", numerator, denominator);
}



-(double) convertToNum {
    if (denominator != 0)
        return (double) numerator / denominator;
    else
        return NAN;
}

//
-(void) setTo: (int) n over: (int) d {
    numerator = n;
    denominator = d;
}

-(Fraction *) add: (Fraction *) f
{
    Fraction *result = [[Fraction alloc] init];
    
    result.numerator = numerator + f.numerator;
    result.denominator = denominator + f.denominator;
    
    return result;
}


@end

/*
 Note that init is defined to return an id type. That’s the general rule for writing init methods for a class that might be subclassed.
 */
