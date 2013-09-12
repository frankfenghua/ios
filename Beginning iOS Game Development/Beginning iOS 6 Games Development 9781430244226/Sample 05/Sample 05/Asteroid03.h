//
//  Asteroid03.h
//  Sample 05
//
//  Created by Lucas Jordan on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#define NUMBER_OF_IMAGES 31

#import <Foundation/Foundation.h>
#import "Actor03.h"

NSMutableArray* imageNameVariations;
@interface Asteroid03 : Actor03 {
    
}
@property (nonatomic) int imageNumber;
@property (nonatomic, strong) NSString* imageVariant;

+(NSMutableArray*)imageNameVariations;
+(id)asteroid:(Example03Controller*)controller;
@end
