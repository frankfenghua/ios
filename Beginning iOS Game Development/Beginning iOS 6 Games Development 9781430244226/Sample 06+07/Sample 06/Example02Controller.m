//
//  Example02Controller.m
//  Sample 06
//
//  Created by Lucas Jordan on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Example02Controller.h"
#import "Saucer.h"
#import "Bullet.h"
#import "Shield.h"

@implementation Example02Controller

-(BOOL)doSetup
{
    if ([super doSetup]){
        NSMutableArray* classes = [NSMutableArray new];
        [classes addObject:[Saucer class]];
        [classes addObject:[Bullet class]];
        
        [self setSortedActorClasses:classes];
        return YES;
    }
    return NO;
}

-(void)updateScene{
    
    NSMutableSet* suacers = [self actorsOfType:[Saucer class]];
    
    if ([suacers count] == 0){
        Saucer* saucer = [Saucer saucer:self];
        [self addActor: saucer];
    }
    
    if (self.stepNumber % (30) == 0){
        float direction = M_PI - M_PI/30.0;
        float rand = (arc4random()%100)/100.0 * M_PI/15.0;
        direction += rand;
        Bullet* bullet = [Bullet bulletAt:CGPointMake(1000, 768/2) WithDirection:direction];
        [self addActor: bullet];

        if (arc4random()%4 == 0){
            if (arc4random()%2 == 0){
                [bullet setDamage:20.0];
            } else {
                [bullet setDamage:30.0];
            }
        }
    }
    
    NSMutableSet* bullets = [self actorsOfType:[Bullet class]];
    
    for (Bullet* bullet in bullets){
        for (Saucer* saucer in suacers){
            if ([bullet overlapsWith:saucer]){
               [saucer doHit:bullet with:self];
            }
        }
    }
    [super updateScene];
}

@end
