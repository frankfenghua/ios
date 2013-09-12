//
//  Powerup.m
//  Sample 06
//
//  Created by Lucas Jordan on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Powerup.h"
#import "GameController.h"
#import "LinearMotion.h"


@implementation Powerup

+(id)powerup:(GameController*)gameController{
    CGSize gameSize = [gameController gameAreaSize];
    
    float startY = gameSize.height * ((arc4random()%1000)/1000.0f);
    float startX = gameSize.width + 64;
    
    CGPoint center = CGPointMake(startX, startY);
    return [Powerup powerup:gameController At: center];
}
+(id)powerup:(GameController*)gameController At:(CGPoint)center{
    
    ImageRepresentation* rep = [ImageRepresentation imageRep];
    [rep setBackwards:arc4random()%2 == 0];
    [rep setStepsPerFrame:1 + arc4random()%3];
    
    
    Powerup* powerup = [[Powerup alloc] initAt:center WithRadius:32 AndRepresentation:rep];
    [rep setDelegate:powerup];
    float rotation = arc4random()%100/100.0 * M_PI*2;
    [powerup setRotation:rotation];
    [powerup setVariant:arc4random()%PWR_VARIATION_COUNT];
    [powerup setState:STATE_GLOW];
    [powerup setRadius:16];
    
    
    LinearMotion* linearMotion = [LinearMotion linearMotionInDirection: DIRECTION_LEFT AtSpeed: 2.0];
    [powerup addBehavior:linearMotion];

    
    return powerup;
}
-(NSString*)baseImageName{
    return @"powerup";
}
-(void)step:(GameController*)gameController{
    if (self.center.x < -self.radius){
        [gameController removeActor:self];
        return;
    }
    if (self.center.x < 120){
        if ([gameController stepNumber] % 25 == 0){
            if (self.state == STATE_GLOW){
                self.state = STATE_NO_GLOW;
            } else {
                self.state = STATE_GLOW;
            }
        }
    }
}
-(int)getFrameCountForVariant:(int)aVariant AndState:(int)aState{
    return 63;
}
-(NSString*)getNameForVariant:(int)aVariant{
    if (aVariant == VARIATION_HEALTH){
        return @"health";
    } else if (aVariant == VARIATION_CASH){
        return @"cash";
    } else if (aVariant == VARIATION_DAMAGE){
        return @"damage";
    } else {
        return nil;
    }
}
-(NSString*)getNameForState:(int)aState{
    if (aState == STATE_GLOW){
        return @"glow";
    } else if (aState == STATE_NO_GLOW){
        return @"noglow";
    } else {
        return nil;
    }
}
-(void)stepsUpdated:(ExpireAfterTime*)expire In:(GameController*)controller{
    long stepsRemaining = [expire stepsRemaining];
    if (stepsRemaining < 60*5){
        if (stepsRemaining % 25 == 0){
            if (self.state == STATE_GLOW){
                self.state = STATE_NO_GLOW;
            } else {
                self.state = STATE_GLOW;
            }
        }
    }
}
-(void)doHitOn:(Viper*)viper in:(GameController*)gameController{
    if (self.variant == VARIATION_HEALTH){
        [viper incrementHealth:30];
    } else if (self.variant == VARIATION_DAMAGE){
        [viper incrementDamage:gameController];
    } else if (self.variant == VARIATION_CASH){
        [gameController incrementScore:1000];
    }
    [gameController removeActor:self];
}

@end
