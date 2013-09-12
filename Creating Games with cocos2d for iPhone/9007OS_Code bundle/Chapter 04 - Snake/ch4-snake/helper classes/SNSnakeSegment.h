//
//  SNSnakeSegment.h
//  ch4-snake
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SNDefinitions.h"

@interface SNSnakeSegment : CCSprite {
    CGPoint _priorPosition; // The coordinates of the prior position of the segment
    SNSnakeSegment *_parentSegment; // Reference to the segment in front of this segment
}

@property (nonatomic, assign) CGPoint priorPosition;
@property (nonatomic, assign) SNSnakeSegment *parentSegment;

@end
