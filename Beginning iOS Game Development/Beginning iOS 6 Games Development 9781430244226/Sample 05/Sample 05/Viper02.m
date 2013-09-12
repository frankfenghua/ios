//
//  Viper02.m
//  Sample 05
//
//  Created by Lucas Jordan on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Viper02.h"
#import "Example02Controller.h"


@implementation Viper02
@synthesize moveToPoint;

+(id)viper:(Example02Controller*)controller{
    
    CGSize gameAreaSize = [controller gameAreaSize];                    
    CGPoint center = CGPointMake(gameAreaSize.width/2, gameAreaSize.height/2);

    Viper02* viper = [[Viper02 alloc] initAt:center WithRadius:16 AndImage:@"viper"];
    [viper setMoveToPoint:center];
    [viper setSpeed:.8];
    
    return viper;
}

-(void)step:(Example02Controller*)controller{
    CGPoint c = [self center];
    
    float dx = (moveToPoint.x - c.x);
    float dy = (moveToPoint.y - c.y);
    float theta = atan(dy/dx);
    
    float dxf = cos(theta) * self.speed;
    float dyf = sin(theta) * self.speed;
    
    if (dx < 0){
        dxf *= -1;
        dyf *= -1;
    } 
    
    c.x += dxf;
    c.y += dyf;
    
    if (abs(moveToPoint.x - c.x) < self.speed && abs(moveToPoint.y - c.y) < self.speed){
        c.x = moveToPoint.x;
        c.y = moveToPoint.y;
    }
    
    [self setCenter:c];
}

-(void)doCollision:(Actor02*)actor In:(Example02Controller*)controller{
    CGSize gameAreaSize = [controller gameAreaSize];                    
    CGPoint centerOfGame = CGPointMake(gameAreaSize.width/2, gameAreaSize.height/2);
    self.center = centerOfGame;
    self.moveToPoint = centerOfGame;
    
    [controller removeActor:actor];
}
@end
