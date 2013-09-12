//
//  Asteroid02.m
//  Sample 05
//
//  Created by Lucas Jordan on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Asteroid02.h"
#import "Example02Controller.h"

@implementation Asteroid02

+(id)asteroid:(Example02Controller*)controller{
    
    CGSize gameAreaSize = [controller gameAreaSize];
    
    float radius = arc4random()%8+8;
    float x = radius + arc4random()%(int)(gameAreaSize.width+radius*2);                               
    CGPoint center = CGPointMake(x, -radius);
    NSString* imageName = [[Asteroid02 imageNameVariations] objectAtIndex:arc4random()%3];
    
    Asteroid02* asteroid = [[Asteroid02 alloc] initAt:center WithRadius:radius AndImage: imageName];
    
    float speed = (arc4random()%10)/10.0 + .1;
    
    [asteroid setSpeed: speed];
    
    return asteroid;
    
}
+(NSMutableArray*)imageNameVariations{
    if (imageNameVariations == nil){
        imageNameVariations = [NSMutableArray new];
        [imageNameVariations addObject:@"AsteroidA"];
        [imageNameVariations addObject:@"AsteroidB"];
        [imageNameVariations addObject:@"AsteroidC"];
    }
    return imageNameVariations;
}

-(void)step:(Example02Controller*)controller{
    CGPoint newCenter = self.center;
    newCenter.y += self.speed;
    self.center = newCenter;
    
    
    if (newCenter.y - self.radius > controller.gameAreaSize.height){
        [controller removeActor: self];
    }
}
@end
