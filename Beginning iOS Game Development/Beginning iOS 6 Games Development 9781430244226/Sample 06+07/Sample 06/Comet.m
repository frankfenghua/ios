//
//  Comet.m
//  Sample 06
//
//  Created by Lucas Jordan on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Comet.h"
#import "LinearMotion.h"
#import "ExpireAfterTime.h"
#import "Particle.h"
#import "ImageRepresentation.h"

@implementation Comet

+(id)comet:(GameController*)controller{
    CGSize gameSize = [controller gameAreaSize];
    
    CGPoint gameCenter = CGPointMake(gameSize.width/2.0, gameSize.height/2.0);
    
    float directionOffScreen = arc4random()%100/100.0 * M_PI*2;
    float distanceFromCenter = MAX(gameCenter.x,gameCenter.y) * 1.2;
    
    CGPoint center = CGPointMake(gameCenter.x + cosf(directionOffScreen)*distanceFromCenter, gameCenter.y + sinf(directionOffScreen)*distanceFromCenter);
    
    VectorRepresentation* rep = [VectorRepresentation vectorRepresentation];
    
    Comet* comet = [[Comet alloc] initAt:center WithRadius:32 AndRepresentation:rep];
    [rep setDelegate:comet];
    [comet setVariant:arc4random()%VARIATION_COUNT];
    
    float direction = arc4random()%100/100.0 * M_PI*2;
    LinearMotion* motion = [LinearMotion linearMotionInDirection:direction AtSpeed:1];
    [motion setWrap:YES];
    [comet addBehavior: motion];
    
    ExpireAfterTime* expire = [ExpireAfterTime expireAfter:60*15];
    [comet addBehavior: expire];
    
    return comet;
}
-(void)step:(GameController*)controller{
    if ([controller stepNumber]%3 == 0){
        VectorRepresentation* rep = [VectorRepresentation vectorRepresentation];
        [rep setDelegate:self];
        
        int totalStepsAlive = arc4random()%60 + 60;
        Particle* particle = [Particle particleAt:self.center WithRep:rep Steps:totalStepsAlive];
        [particle setRadius:self.radius];
        [controller addActor: particle];
    }
}
-(void)drawActor:(Actor*)anActor WithContext:(CGContextRef)context InRect:(CGRect)rect{
    CGContextClearRect(context,rect);
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    
    CGFloat locations[4];
    locations[0] = 0.0;
    locations[1] = 0.1;
    locations[2] = 0.2;
    locations[3] = 1.0;
    
    
    UIColor* color1 = nil;
    UIColor* color2 = nil;
    UIColor* color3 = nil;
    
    float whiter = 0.6;
    float c2alpha = 0.5;
    float c3aplha = 0.3;
    
    if (self.variant == VARIATION_RED){
        color1 = [UIColor colorWithRed:1.0 green:whiter blue:whiter alpha:1.0];
        color2 = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:c2alpha];
        color3 = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:c3aplha];
    } else if (self.variant == VARIATION_GREEN){
        color1 = [UIColor colorWithRed:whiter green:1.0 blue:whiter alpha:1.0];
        color2 = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:c2alpha];
        color3 = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:c3aplha];
    } else if (self.variant == VARIATION_BLUE){
        color1 = [UIColor colorWithRed:whiter green:whiter blue:1.0 alpha:1.0];
        color2 = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:c2alpha];
        color3 = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:c3aplha];
    } else if (self.variant == VARIATION_CYAN){
        color1 = [UIColor colorWithRed:whiter green:1.0 blue:1.0 alpha:1.0];
        color2 = [UIColor colorWithRed:0.0 green:1.0 blue:1.0 alpha:c2alpha];
        color3 = [UIColor colorWithRed:0.0 green:1.0 blue:1.0 alpha:c3aplha];
    } else if (self.variant == VARIATION_MAGENTA){
        color1 = [UIColor colorWithRed:1.0 green:whiter blue:1.0 alpha:1.0];
        color2 = [UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:c2alpha];
        color3 = [UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:c3aplha];
    } else if (self.variant == VARIATION_YELLOW){
        color1 = [UIColor colorWithRed:1.0 green:1.0 blue:whiter alpha:1.0];
        color2 = [UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:c2alpha];
        color3 = [UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:c3aplha];
    }
    UIColor* color4 = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    
    
    CGColorRef clr[] = { [color1 CGColor], [color2 CGColor] , [color3 CGColor], [color4 CGColor]};
    CFArrayRef colors = CFArrayCreate(NULL, (const void**)clr, sizeof(clr) / sizeof(CGColorRef), &kCFTypeArrayCallBacks);
    
    CGGradientRef grad = CGGradientCreateWithColors(space, colors, locations);
    CGColorSpaceRelease(space);
    
    CGContextDrawRadialGradient(context, grad, CGPointMake(self.radius, self.radius), 0, CGPointMake(self.radius, self.radius), self.radius, 0);
    
    CGGradientRelease(grad);
}

@end
