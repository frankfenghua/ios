//
//  Spark.h
//  Sample 08
//
//  Created by Lucas Jordan on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Actor.h"
#import "ImageRepresentation.h"

enum{
    SPK_VARIATION_RED = 0,
    SPK_VARIATION_GREEN,
    SPK_VARIATION_BLUE,
    SPK_VARIATION_CYAN,
    SPK_VARIATION_MAGENTA,
    SPK_VARIATION_YELLOW,
    SPK_VARIATION_COUNT
};

@interface Spark : Actor<ImageRepresentationDelegate>

+(id)spark:(int)aVariant At:(CGPoint)aCenter;
@end
