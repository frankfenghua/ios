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
    CGPoint aCenter = CGPointMake(64, gameSize.height/2.0);
    
    Viper* viper = [[Viper alloc] initAt:aCenter WithRadius:32 AndRepresentation:rep];
    [rep setDelegate:viper];
    
    return viper;
}
-(NSString*)baseImageName{
    return @"viper";
}
-(NSString*)getNameForState:(int)aState{
    return @"stopped";
}
@end
