//
//  Sample01Controller.m
//  Sample 06
//
//  Created by Lucas Jordan on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Example01Controller.h"
#import "Powerup.h"

@implementation Example01Controller
 
-(void)updateScene{
    if (self.stepNumber % (60*5) == 0){
        [self addActor:[Powerup powerup: self]];
    }
    [super updateScene];
}

@end
