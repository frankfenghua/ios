//
//  Asteroid03.m
//  Sample 05
//
//  Created by Lucas Jordan on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Asteroid03.h"
#import "Example03Controller.h"

@implementation Asteroid03
@synthesize imageNumber;
@synthesize imageVariant;

+(id)asteroid:(Example03Controller*)controller{
    
    CGSize gameAreaSize = [controller gameAreaSize];
    
    float radius = arc4random()%8+8;
    float x = radius + arc4random()%(int)(gameAreaSize.width+radius*2);                               
    CGPoint center = CGPointMake(x, -radius);
    
    Asteroid03* asteroid = [[Asteroid03 alloc] initAt:center WithRadius:radius AndImage: nil];
    
    float speed = (arc4random()%10)/10.0 + .1;
    [asteroid setSpeed: speed];
    
    NSString* imageVariant = [[Asteroid03 imageNameVariations] objectAtIndex:arc4random()%3];
    [asteroid setImageVariant:imageVariant];
    
    return asteroid;
    
}
+(NSMutableArray*)imageNameVariations{
    if (imageNameVariations == nil){
        imageNameVariations = [NSMutableArray new];
        [imageNameVariations addObject:@"Asteroid_A"];
        [imageNameVariations addObject:@"Asteroid_B"];
        [imageNameVariations addObject:@"Asteroid_C"];
    }
    return imageNameVariations;
}
-(NSString*)imageName{
    return [[imageVariant stringByAppendingString:@"_"] stringByAppendingString:[NSString stringWithFormat:@"%04d", self.imageNumber]];
}

-(void)step:(Example03Controller*)controller{
    if ([controller stepNumber]%2 == 0){
        self.imageNumber = imageNumber+1;
        if (self.imageNumber > NUMBER_OF_IMAGES) {
            self.imageNumber = 1;
        }
        self.needsImageUpdated = YES;
    } else {
        self.needsImageUpdated = NO;
    }
    
    CGPoint newCenter = self.center;
    newCenter.y += self.speed;
    self.center = newCenter;
    
    if (newCenter.y - self.radius > controller.gameAreaSize.height){
        [controller removeActor: self];
    }
}
@end