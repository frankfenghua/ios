//
//  Fraction.m
//  prog4
//
//  Created by fenghua on 2013-08-16.
//  Copyright (c) 2013 fenghua. All rights reserved.
//

#import "Fraction.h"

@implementation Fraction
//{
//    int numerator;
//    int denominator;
//}
@synthesize numerator;
@synthesize denominator;

-(void) print {
    NSLog (@"%i/%i", numerator, denominator);
}

//-(void) setNumerator: (int) n {
//    numerator = n;
//}
//
//-(void) setDenominator: (int) d {
//    denominator = d;
//}
//
//-(int) numerator {
//    return numerator;
//}
//
//-(int) denominator {
//    return denominator;
//}

-(double) convertToNum {
    if (denominator != 0)
        return (double) numerator / denominator;
    else
        return NAN;
}

@end
