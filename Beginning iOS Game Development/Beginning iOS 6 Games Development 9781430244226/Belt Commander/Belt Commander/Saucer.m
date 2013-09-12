//
//  Saucer.m
//  Sample 06
//
//  Created by Lucas Jordan on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



#import "Saucer.h"
#import "GameController.h"
#import "LinearMotion.h"
#import "Bullet.h"
#import "BeltCommanderController.h"


@implementation Saucer
@synthesize maxHealth;
@synthesize health;
@synthesize speed;
@synthesize healthBar;

-(id)initAt:(CGPoint)aPoint WithRadius:(float)aRadius AndRepresentation:(NSObject<Representation> *)aRepresentation withDirection:(float)direction withSpeed:(float)aSpeed{
    
    self = [self initAt:aPoint WithRadius:aRadius AndRepresentation:aRepresentation];
    linearMotion = [LinearMotion linearMotionInDirection:direction AtSpeed: aSpeed];
    speed = aSpeed;
    [self addBehavior:linearMotion];
    
    return self;
}
+(id)saucer:(GameController*)controller{
    CGSize gameAreaSize = [controller gameAreaSize];
    
    ImageRepresentation* rep = [ImageRepresentation imageRep];
    [rep setBackwards:arc4random()%2 == 0];
    [rep setStepsPerFrame:3];
    
    float radius = arc4random()%1000/1000.0f*16+16;
    float speed = 1 + arc4random()%1000/1000.0f*.5;
    float direction = DIRECTION_DOWN;
    
    float x = (gameAreaSize.width - radius*1.5) - arc4random()%1000/1000.0f*gameAreaSize.width/2.0;
    CGPoint center = CGPointMake(x, -radius);
    if (arc4random()%2 == 0){
        center.y = gameAreaSize.height + radius;
        direction = DIRECTION_UP;
    } 
    
    Saucer* saucer = [[Saucer alloc] initAt:center WithRadius:radius AndRepresentation:rep withDirection:direction withSpeed:speed];
    [rep setDelegate:saucer];
    
    [saucer setVariant:arc4random()%VARIATION_COUNT];
    [saucer setMaxHealth:30];
    [saucer setHealth:30];
    
    HealthBar* healthBar = [HealthBar healthBar:saucer];
    [healthBar setPercent:1];
    [saucer setHealthBar:healthBar];
    [controller addActor:healthBar];
    
    return saucer;
}
-(void)step:(GameController*)gameController{
    if (health <= 0){
        [gameController incrementScore:[self radius]*10];
        [gameController removeActor:self];
        return;
    }
    
    CGSize gameAreaSize = [gameController gameAreaSize];
    CGPoint center = [self center];
    
    if (center.y < -[self radius]){
        [linearMotion setDirection:DIRECTION_DOWN];
    } else if (center.y > gameAreaSize.height + [self radius]){
        [linearMotion setDirection:DIRECTION_UP];
    }
    if (arc4random()%180 == 0){
        BeltCommanderController* bc = (BeltCommanderController*)gameController;
        
        [gameController addActor:[Bullet bulletAt:[self center] TowardPoint:[bc viper].center From:self]];
    }
}
-(void)incrementHealth:(float)amount{
    health += amount;
    if (health > maxHealth){
        health = maxHealth;
    }
    [healthBar setPercent:health/maxHealth];
}
-(void)decrementHealth:(float)amount{
    health -= amount;
    [healthBar setPercent:health/maxHealth];
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

@end
