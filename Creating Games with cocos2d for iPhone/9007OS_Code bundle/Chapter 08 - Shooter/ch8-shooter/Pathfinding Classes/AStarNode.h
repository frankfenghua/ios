//
//  AStarNode.h
//  ch8-shooter
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// A class that represents a step of the computed path
@interface AStarNode : NSObject
{
	CGPoint position;
	int gScore;
	int hScore;
    AStarNode *parent;
}

@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) int gScore;
@property (nonatomic, assign) int hScore;
@property (nonatomic, assign) AStarNode *parent;

- (id)initWithPosition:(CGPoint)pos;
- (int)fScore;

@end

