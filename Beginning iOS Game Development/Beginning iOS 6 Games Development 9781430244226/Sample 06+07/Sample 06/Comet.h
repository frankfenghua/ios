//
//  Comet.h
//  Sample 06
//
//  Created by Lucas Jordan on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Actor.h"
#import "GameController.h"
#import "VectorRepresentation.h"

enum{
    VARIATION_RED = 0,
    VARIATION_GREEN,
    VARIATION_BLUE,
    VARIATION_CYAN,
    VARIATION_MAGENTA,
    VARIATION_YELLOW,
    VARIATION_COUNT
};

@interface Comet : Actor<VectorRepresentationDelegate> {
    
}
+(id)comet:(GameController*)controller;
@end
