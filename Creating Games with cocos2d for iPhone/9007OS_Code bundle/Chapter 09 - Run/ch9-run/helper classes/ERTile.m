//
//  ERTile.m
//  ch9-run
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "ERTile.h"

@implementation ERTile

@synthesize topSensor;
@synthesize isTop;

#pragma mark Sensors
-(void) defineSensors {
    topSensor = CGRectMake(self.boundingBox.origin.x,
                           self.boundingBox.origin.y + self.boundingBox.size.height - 10,
                           self.boundingBox.size.width,
                           5);
}

-(void) setPosition:(CGPoint)position {
    // Override set position so we can keep the sensors
    // together with sprite
    [super setPosition:position];
    
    if (isTop) {
        [self defineSensors];
    }
}

@end
