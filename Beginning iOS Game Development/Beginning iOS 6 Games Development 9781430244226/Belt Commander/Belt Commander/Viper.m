//
//  Viper.m
//  Sample 08
//
//  Created by Lucas Jordan on 8/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Viper.h"
#import "Bullet.h"

@implementation Viper
@synthesize health, maxHealth, lastShot, stepsPerShot, shootTop, damage;

+(id)viper:(GameController*)gameController{
    ImageRepresentation* rep = [ImageRepresentation imageRep];
    
    CGSize gameSize = [gameController gameAreaSize];
    CGPoint aCenter = CGPointMake(64, gameSize.height/2.0);
    
    Viper* viper = [[Viper alloc] initAt:aCenter WithRadius:32 AndRepresentation:rep];
    [rep setDelegate:viper];
    
    [viper setHealth:100.0];
    [viper setMaxHealth:100.0];
    [viper setLastShot:0];
    [viper setStepsPerShot:55];
    [viper incrementDamage:gameController];
    
    return viper;
}
-(NSString*)baseImageName{
    return @"viper";
}
-(NSString*)getNameForState:(int)aState{
    switch (aState) {
        case VPR_STATE_STOPPED:
            return @"stopped";
        case VPR_STATE_UP:
            return @"up";
        case VPR_STATE_DOWN:
            return @"down";
    }
    return nil;
}
-(void)step:(GameController*)gameController{
    long stepNumber = [gameController stepNumber];
    if (stepNumber - lastShot > stepsPerShot - damage){
        
        [gameController playAudio:AUDIO_BLIP];
        
        CGPoint center = [self center];
        CGSize gameSize = [gameController gameAreaSize];
        
        float offset;
        if (shootTop){
            offset = -15;
        } else {
            offset = 15;
        }
        
        CGPoint bCenter = CGPointMake(center.x + 20, center.y + offset);
        CGPoint bToward = CGPointMake(gameSize.width, bCenter.y);
        
        Bullet* bullet = [Bullet bulletAt:bCenter TowardPoint:bToward From:self];
        [bullet setDamage:damage];
        [gameController addActor:bullet];
        
        shootTop = !shootTop;
        lastShot = stepNumber;
    }
    if (stepNumber % 60 == 0){
        [self incrementHealth:1];
    }
    if (lastStepDamageWasModified + 10*60 == stepNumber){
        [self decrementDamage:gameController];
    }
}
-(void)incrementHealth:(float)amount{
    health += amount;
    if (health > maxHealth){
        health = maxHealth;
    }
}
-(void)decrementHealth:(float)amount{
    health -= amount;
}
-(void)incrementDamage:(GameController*)gameController{
    damage += 10;
    if (damage < 10){
        damage = 10;
    } else if (damage > 30){
        damage = 30;
    }
    lastStepDamageWasModified = [gameController stepNumber];
}
-(void)decrementDamage:(GameController*)gameController{
    damage -= 10;
    if (damage < 10){
        damage = 10;
    }
    lastStepDamageWasModified = [gameController stepNumber];
}
-(void)setMoveToPoint:(CGPoint)aPoint within:(GameController*)gameController{
    if (motion){
        [[self behaviors] removeObject: motion];
    }
    CGPoint point = CGPointMake([self center].x, aPoint.y);
    
    if (point.y < self.center.y){
        [self setState:VPR_STATE_UP];
    } else if (point.y > self.center.y){
        [self setState:VPR_STATE_DOWN];
    }

    
    motion = [LinearMotion linearMotionFromPoint:[self center] toPoint:point AtSpeed:1.2f];
    [motion setDelegate:self];
    [motion setStopAtPoint:YES];
    [motion setPointToStopAt:point];
    
    [motion setStayInRect:YES];
    CGSize gameSize = [gameController gameAreaSize];
    [motion setRectToStayIn:CGRectMake(63, 31, 2, gameSize.height - 63)];
    
    [motion setWrap:NO];
    
    [[self behaviors] addObject:motion];
    
}
-(void)linearMotion:(LinearMotion*)linearMotion stoppedAtPoint:(CGPoint)aPoint{
    [self setState: VPR_STATE_STOPPED];
}
@end
