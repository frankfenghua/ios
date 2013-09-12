//
//  Asteroid.m
//  Sample 06
//
//  Created by Lucas Jordan on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Asteroid.h"
#import "LinearMotion.h"
#import "ExpireAfterTime.h"
#import "Particle.h"

@implementation Asteroid
@synthesize level;

+(id)asteroid:(GameController*)acontroller{
    CGSize gameSize = [acontroller gameAreaSize];
    
    CGPoint gameCenter = CGPointMake(gameSize.width/2.0, gameSize.height/2.0);
    
    float directionOffScreen = arc4random()%100/100.0 * M_PI*2;
    float distanceFromCenter = MAX(gameCenter.x,gameCenter.y) * 1.2;
    
    CGPoint center = CGPointMake(gameCenter.x + cosf(directionOffScreen)*distanceFromCenter, gameCenter.y + sinf(directionOffScreen)*distanceFromCenter);

    return [Asteroid asteroidOfLevel:4 At:center];
}
+(id)asteroidOfLevel:(int)aLevel At:(CGPoint)aCenter{
    
    ImageRepresentation* rep = [ImageRepresentation imageRepWithDelegate:[AsteroidRepresentationDelegate instance]];
    [rep setBackwards:arc4random()%2 == 0];
    if (aLevel >= 4){
        [rep setStepsPerFrame:arc4random()%2+2];
    } else {
        [rep setStepsPerFrame:arc4random()%4+1];
    }
    
    Asteroid* asteroid = [[Asteroid alloc] initAt:aCenter WithRadius:4 + aLevel*7 AndRepresentation:rep];
    
    [asteroid setLevel:aLevel];
    [asteroid setVariant:arc4random()%AST_VARIATION_COUNT];
    [asteroid setRotation: (arc4random()%100)/100.0*M_PI*2];
    
    float direction = arc4random()%100/100.0 * M_PI*2;
    LinearMotion* motion = [LinearMotion linearMotionInDirection:direction AtSpeed:1];
    [motion setWrap:YES];
    [asteroid addBehavior:motion];
    
    return asteroid;
}
-(int)getFrameCountForVariant:(int)aVariant AndState:(int)aState{
    return 31;
}
-(NSString*)getNameForVariant:(int)aVariant{
    if (aVariant == VARIATION_A){
        return @"A";
    } else if (aVariant == VARIATION_B){
        return @"B";
    } else if (aVariant == VARIATION_C){
        return @"C";
    } else {
        return nil;
    }
    
}
-(NSString*)baseImageName{
    return @"Asteroid";
}
-(void)doHit:(GameController*)controller{
    if (level > 1){
        int count = arc4random()%3+1;
        for (int i=0;i<count;i++){
            Asteroid* newAst = [Asteroid asteroidOfLevel:level-1 At:self.center];
            [controller addActor:newAst];
        }
    }
    
    int particles = arc4random()%5+1;
    for (int i=0;i<particles;i++){
        ImageRepresentation* rep = [ImageRepresentation imageRepWithDelegate:[AsteroidRepresentationDelegate instance]];
        Particle* particle = [Particle particleAt:self.center WithRep:rep Steps:25];
        [particle setRadius:6];
        [particle setVariant:arc4random()%AST_VARIATION_COUNT];
        [particle setRotation: (arc4random()%100)/100.0*M_PI*2];
        
        LinearMotion* motion = [LinearMotion linearMotionRandomDirectionAndSpeed];
        [particle addBehavior:motion];
        
        [controller addActor: particle];
    }
    [controller removeActor:self];
}
@end
