//
//  Saucer.m
//  Sample 06
//
//  Created by Lucas Jordan on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Saucer.h"
#import "GameController.h"
#import "Shield.h"

@implementation Saucer
@synthesize maxHealth;
@synthesize currentHealth;
@synthesize healthBar;

+(id)saucer:(GameController*)controller{
    CGSize gameAreaSize = [controller gameAreaSize];
    CGPoint gameCenter = CGPointMake(gameAreaSize.width/2.0, gameAreaSize.height/2.0);
    
    ImageRepresentation* rep = [ImageRepresentation imageRep];
    [rep setBackwards:arc4random()%2 == 0];
    [rep setStepsPerFrame:3];
    
    Saucer* saucer = [[Saucer alloc] initAt:gameCenter WithRadius:32 AndRepresentation:rep];
    [rep setDelegate:saucer];
    
    [saucer setVariant:arc4random()%VARIATION_COUNT];
    [saucer setMaxHealth:100];
    [saucer setCurrentHealth:100];
    
    HealthBar* healthBar = [HealthBar healthBar:saucer];
    [healthBar setPercent:1];
    [saucer setHealthBar:healthBar];
    [controller addActor:healthBar];
    
    return saucer;
}
-(int)getFrameCountForVariant:(int)aVariant AndState:(int)aState{
    return 31;
}
-(NSString*)baseImageName{
    return @"saucer";
}
-(NSString*)getNameForVariant:(int)aVariant{
    if (aVariant == VARIATION_CYAN){
        return @"cyan";
    } else if (aVariant == VARIATION_MAGENTA){
        return @"magenta";
    } else if (aVariant == VARIATION_YELLOW){
        return @"yellow";
    } else {
        return nil;
    }
}
-(void)doHit:(Bullet*)bullet with:(GameController*)controller{
    [controller addActor:[Shield shieldProtecting:self From:bullet]];
    [controller removeActor:bullet];
    currentHealth -= [bullet damage];
    [healthBar setPercent:currentHealth/maxHealth];
    if (currentHealth <= 0){
        [controller removeActor:self];
    }
}
@end
