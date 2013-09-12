//
//  TouchEventsView.m
//  Sample 08
//
//  Created by Lucas Jordan on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TouchEventsView.h"
#import "Spark.h"

@implementation TouchEventsView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"Begin: %i", [touches count]);
    sparks = [NSMutableArray new];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"Cancelled: %i", [touches count]);
    
    for (Spark* spark in sparks){
        [controller removeActor:spark];
    }
    
    [sparks removeAllObjects];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"Ended: %i", [touches count]);
    int count = [touches count];
    
    for (UITouch* touch in touches){
        Spark* spark = [Spark spark:count-1 At:[touch locationInView:self]];
        [controller addActor:spark];
        [sparks addObject:spark];
    }
    
    [sparks removeAllObjects];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"Moved: %i", [touches count]);
    int count = [touches count];
    
    for (UITouch* touch in touches){
        Spark* spark = [Spark spark:count-1 At:[touch locationInView:self]];
        [controller addActor:spark];
        [sparks addObject:spark];
    }
}
@end
