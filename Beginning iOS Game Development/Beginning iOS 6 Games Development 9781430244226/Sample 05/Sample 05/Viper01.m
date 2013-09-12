//
//  Viper01.m
//  Sample 05
//
//  Created by Lucas Jordan on 4/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Viper01.h"


@implementation Viper01 
@synthesize moveToPoint;
@synthesize speed;

-(id)init{
    self = [super initWithImage:[UIImage imageNamed:@"viper"]];
    if (self != nil){
        [self setSpeed:1.2];
    }
    return self;
}
-(void)updateLocation{
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
    
    if (abs(moveToPoint.x - c.x) < speed && abs(moveToPoint.y - c.y) < speed){
        c.x = moveToPoint.x;
        c.y = moveToPoint.y;
    }
    
    [self setCenter:c];
}
@end
