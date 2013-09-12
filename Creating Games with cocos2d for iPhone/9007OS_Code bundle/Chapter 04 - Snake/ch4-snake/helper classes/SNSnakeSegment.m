//
//  SNSnakeSegment.m
//  ch4-snake
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "SNSnakeSegment.h"

@implementation SNSnakeSegment

@synthesize priorPosition = _priorPosition;
@synthesize parentSegment = _parentSegment;

-(void) setPosition:(CGPoint)position {
    // override the method to let us keep the prior position
    self.priorPosition = self.position;
    [super setPosition:position];
}

@end
