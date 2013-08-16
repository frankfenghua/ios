//
//  Complex.h
//  Polymorphism
//
//  Created by fenghua on 2013-08-16.
//  Copyright (c) 2013 fenghua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Complex : NSObject
@property double real, imaginary;

-(void) print;
-(void) setReal:(double) a andImaginary:(double) b;
-(Complex *) add: (Complex *) f;
@end
