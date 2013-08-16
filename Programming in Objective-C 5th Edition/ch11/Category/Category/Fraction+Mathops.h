//
//  Fraction+Mathops.h
//  Category
//
//  Created by fenghua on 2013-08-16.
//  Copyright (c) 2013 fenghua. All rights reserved.
//

#import "Fraction.h"

@interface Fraction(Mathops)

-(Fraction *) add: (Fraction *) f;
-(Fraction *) sub: (Fraction *) f;
-(Fraction *) mul: (Fraction *) f;
-(Fraction *) div: (Fraction *) f;
@end
