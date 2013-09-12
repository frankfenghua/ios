//
//  Spark.m
//  Sample 08
//
//  Created by Lucas Jordan on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Spark.h"
#import "ExpireAfterTime.h"

@implementation Spark

+(id)spark:(int)aVariant At:(CGPoint)aCenter{
    
    ImageRepresentation* rep = [ImageRepresentation imageRep];
    Spark* spark = [[Spark alloc] initAt:aCenter WithRadius:32 AndRepresentation:rep];
    [spark setVariant: MIN(aVariant, SPK_VARIATION_COUNT-1)];
    [rep setDelegate:spark];
    
    ExpireAfterTime* expire = [ExpireAfterTime expireAfter: 60*5];
    [spark addBehavior: expire];
    
    return spark;
}
-(NSString*)baseImageName{
    return @"spark";
}
-(NSString*)getNameForVariant:(int)aVariant{
    if (aVariant == SPK_VARIATION_RED){
        return @"red";
    } else if (aVariant == SPK_VARIATION_GREEN){
        return @"green";
    } else if (aVariant == SPK_VARIATION_BLUE){
        return @"blue";
    } else if (aVariant == SPK_VARIATION_CYAN){
        return @"cyan";
    } else if (aVariant == SPK_VARIATION_MAGENTA){
        return @"magenta";
    } else if (aVariant == SPK_VARIATION_YELLOW){
        return @"yellow";
    } else {
        return nil;
    }
}
@end
