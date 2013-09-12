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
#import "LinearMotion.h"
#import "HealthBar.h"

enum{
    VARIATION_CYAN = 0,
    VARIATION_MAGENTA,
    VARIATION_YELLOW,
    VARIATION_COUNT
};

@interface Saucer : Actor<ImageRepresentationDelegate> {
    LinearMotion* linearMotion;
}
@property (nonatomic) float maxHealth;
@property (nonatomic) float health;
@property (nonatomic) float speed;
@property (nonatomic, retain) HealthBar* healthBar;

+(id)saucer:(GameController*)controller;
-(void)incrementHealth:(float)amount;
-(void)decrementHealth:(float)amount;
@end
