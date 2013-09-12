//
//  HealthBarView.m
//  Belt Commander
//
//  Created by Lucas Jordan on 8/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HealthBarView.h"

@implementation HealthBarView

-(void)setColorRanged:(NSArray*)thePercents colors:(NSArray*)theColors{
    percents = thePercents;
    colors = theColors;
    [self setNeedsDisplay];
}
-(void)setHealth:(float)aPercent{
    if (percent != aPercent){
        percent = aPercent;
        if (percent > 1.0f){
            percent = 1.0f;
        } else if (percent < 0.0f){
            percent = 0.0;
        }
        [self setNeedsDisplay];
    }
}
-(void)setDefaults{
    if (colors == nil){
        percents = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.3f], [NSNumber numberWithFloat:0.6f],[NSNumber numberWithFloat:1.0f], nil];
        percent = 0.5f;
        colors = [NSArray arrayWithObjects:[UIColor redColor], [UIColor orangeColor], [UIColor blueColor], nil];
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
}
- (void)drawRect:(CGRect)rect
{
    [self setDefaults];
    int index = 0;
    
    float marker = [[percents objectAtIndex:index] floatValue];
    
    while (percent > marker) {
        marker = [[percents objectAtIndex:++index] floatValue];
    }
    
    UIColor* baseColor = [colors objectAtIndex:index];
    const float* rgb = CGColorGetComponents( baseColor.CGColor );

    
    UIColor* frameColor = [UIColor colorWithRed:rgb[0] green:rgb[1] blue:rgb[2] alpha:.8f];
    UIColor* healthColor = [UIColor colorWithRed:rgb[0] green:rgb[1] blue:rgb[2] alpha:.5f];
    
    [frameColor setStroke];
    [healthColor setFill];
    
    CGSize size = [self frame].size;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect frameRect = CGRectMake(1, 1, size.width-2, size.height-2
                                  );
    CGContextStrokeRect(context, frameRect);
    
    CGRect heatlhRect = CGRectMake(1, 1, (size.width-2)*percent, size.height-2);
    CGContextFillRect(context, heatlhRect);
}


@end
