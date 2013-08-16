//
//  Fraction.h
//  InitializingObjects
//
//  Created by fenghua on 2013-08-16.
//  Copyright (c) 2013 fenghua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fraction : NSObject
@property int numerator;
@property int denominator;

-(id) init;
-(Fraction *) initWith: (int) n over: (int) d ;

-(void) print;
// -(void) setNumerator: (int) n;
// -(void) setDenominator: (int) d;
// -(int)  numerator;
//  -(int) denominator;
-(double) convertToNum;
// Multiple Arguments to Methods
-(void) setTo: (int) n over: (int) d;
-(Fraction *) add: (Fraction *) f;

@end
