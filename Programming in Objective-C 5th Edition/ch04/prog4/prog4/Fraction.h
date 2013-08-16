//
//  Fraction.h
//  prog4
//
//  Created by fenghua on 2013-08-16.
//  Copyright (c) 2013 fenghua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fraction : NSObject

@property int numerator;
@property int denominator;

 -(void) print;
// -(void) setNumerator: (int) n;
// -(void) setDenominator: (int) d;
// -(int)  numerator;
//  -(int) denominator;
  -(double) convertToNum;
// Multiple Arguments to Methods
-(void) setTo: (int) n over: (int) d;
@end

/*
Note t hat when you use t he @property direct ive you no longer need t o declare t he corresponding inst ance variable in your implement at ion sect ion. You can if you want t o, but it ’s no longer necessary; t he compiler t akes care of t hat for you.
The following line tells the Objective-C compiler to generate a pair of getter and setter met hods for each of t he t wo propert ies, numerator and denominator:
*/

/*
  As of Xcode4.5,younolongerneedtousethe@synthesize directive.Usingthe @property directive suffices. The compiler automatically generates the setter and getter for you. We return to this topic later in this chapter.
 */

// Multiple Arguments to Methods
// http://stackoverflow.com/questions/683211/method-syntax-in-objective-c/683290#683290