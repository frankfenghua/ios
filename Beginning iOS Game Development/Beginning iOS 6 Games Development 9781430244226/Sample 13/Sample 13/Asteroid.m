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

+(id)asteroid:(GameController*)gameController{
    CGSize gameSize = [gameController gameAreaSize];
    
    int startLevel = 4;
    
    float startY = gameSize.height * ((arc4random()%1000)/1000.0f);
    float startX = gameSize.width + 64;
        
    CGPoint center = CGPointMake(startX, startY);

    return [Asteroid asteroidOfLevel:startLevel At:center];
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
    
    float direction = M_PI - M_PI/30.0;
    float rand = (arc4random()%100)/100.0 * M_PI/10.0;
    direction += rand;
    
    
    return asteroid;
}
-(b2BodyDef)createBodyDef{
    b2BodyDef bodyDef = [super createBodyDef];
    bodyDef.linearVelocity.Set(-20+rand()%40, -20+rand()%40);
    
    return bodyDef;
}
-(void)step:(GameController *)controller{
    if (self.center.x < -self.radius){
        CGPoint center = CGPointMake(controller.gameAreaSize.width+self.radius, self.center.y);
        self.body->SetTransform([PhysicsViewController convertPointToB2: center], self.body->GetAngle());
    } else if (self.center.x > controller.gameAreaSize.width + self.radius){
        CGPoint center = CGPointMake(-self.radius, self.center.y);
        self.body->SetTransform([PhysicsViewController convertPointToB2: center], self.body->GetAngle());
    }
    if (self.center.y < -self.radius){
        CGPoint center = CGPointMake(self.center.x, controller.gameAreaSize.height + self.radius);
        self.body->SetTransform([PhysicsViewController convertPointToB2: center], self.body->GetAngle());
    } else if (self.center.y > controller.gameAreaSize.height + self.radius){
        CGPoint center = CGPointMake(self.center.x, -self.radius);
        self.body->SetTransform([PhysicsViewController convertPointToB2: center], self.body->GetAngle());
    }
    
    [super step: controller];
}
-(void)doHit:(GameController*)controller{
    if (level > 1){
        int count = 1;
        float percent = arc4random()%1000/1000.0f;
        if (percent > 0.9){
            count = 3;
        } else if (percent > 0.5){
            count = 2;
        }
        for (int i=0;i<count;i++){
            
            float radius = [self radius];
            
            float rx = arc4random()%1000/1000.0*radius*2 - radius;
            float ry = arc4random()%1000/1000.0*radius*2 - radius;
            CGPoint newCenter = CGPointMake(self.center.x + rx, self.center.y + ry);
            
            Asteroid* newAst = [Asteroid asteroidOfLevel:level-1 At: newCenter];
            [controller addActor:newAst];
        }
    }
    
    int particles = arc4random()%4+1;
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
