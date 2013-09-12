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


+(id)powerup:(GameController*)aController At:(CGPoint)center{
    
    ImageRepresentation* rep = [ImageRepresentation imageRep];
    [rep setBackwards:arc4random()%2 == 0];
    [rep setStepsPerFrame:1 + arc4random()%3];
    
    
    Powerup* powerup = [[Powerup alloc] initAt:center WithRadius:32 AndRepresentation:rep];
    [rep setDelegate:powerup];
    float rotation = arc4random()%100/100.0 * M_PI*2;
    [powerup setRotation:rotation];
    [powerup setVariant:arc4random()%PWR_VARIATION_COUNT];
    [powerup setState:STATE_NO_GLOW];
    
    
    return powerup;
}
-(NSString*)baseImageName{
    return @"powerup";
}
-(int)getFrameCountForVariant:(int)aVariant AndState:(int)aState{
    if (aState == STATE_NO_GLOW){
        return 1;
    } else {
        return 63;
    }
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

@end
