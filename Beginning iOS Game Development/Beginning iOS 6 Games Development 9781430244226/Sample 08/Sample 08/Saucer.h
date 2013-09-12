//
//  Saucer.h
//  Sample 06
//
//  Created by Lucas Jordan on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Actor.h"
#import "ImageRepresentation.h"

enum{
    VARIATION_CYAN = 0,
    VARIATION_MAGENTA,
    VARIATION_YELLOW,
    VARIATION_COUNT
};

@interface Saucer : Actor<ImageRepresentationDelegate> {
    
}
@property (nonatomic) float maxHealth;
@property (nonatomic) float currentHealth;

+(id)saucer:(GameController*)controller;

@end
