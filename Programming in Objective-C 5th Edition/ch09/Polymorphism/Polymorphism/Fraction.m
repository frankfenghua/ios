//
//  Fraction.m
//  prog4
//
//  Created by fenghua on 2013-08-16.
//  Copyright (c) 2013 fenghua. All rights reserved.
//

#import "Fraction.h"

@implementation Fraction

@synthesize numerator;
@synthesize denominator;

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
