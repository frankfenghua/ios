//
//  Viper.m
//  Sample 08
//
//  Created by Lucas Jordan on 8/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Viper.h"

@implementation Viper

+(id)viper:(GameController*)gameController{
    ImageRepresentation* rep = [ImageRepresentation imageRep];
    
    CGSize gameSize = [gameController gameAreaSize];
    CGPoint aCenter = CGPointMake(gameSize.width/2.0, gameSize.height/2.0);
    
    Viper* viper = [[Viper alloc] initAt:aCenter WithRadius:32 AndRepresentation:rep];
    [rep setDelegate:viper];
    
    return viper;
}
-(NSString*)baseImageName{
    return @"viper";
}
-(NSString*)getNameForState:(int)aState{
    switch (aState) {
        case VPR_STATE_STOPPED:
            return @"stopped";
        case VPR_STATE_CLOCKWISE:
            return @"clockwise";
        case VPR_STATE_COUNTER_CLOCKWISE:
            return @"counterclockwise";
        case VPR_STATE_TRAVELING:
            return @"traveling";
    }
    return nil;
}
@end
