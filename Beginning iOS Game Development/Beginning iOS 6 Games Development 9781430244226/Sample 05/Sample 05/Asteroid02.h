//
//  Asteroid02.h
//  Sample 05
//
//  Created by Lucas Jordan on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Actor02.h"

NSMutableArray* imageNameVariations;

@interface Asteroid02 : Actor02 {
    
}
+(NSMutableArray*)imageNameVariations;
+(id)asteroid:(Example02Controller*)controller;
@end
