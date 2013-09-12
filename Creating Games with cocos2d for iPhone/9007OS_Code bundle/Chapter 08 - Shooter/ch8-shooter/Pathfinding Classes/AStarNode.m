//
//  AStarNode.m
//  ch8-shooter
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "AStarNode.h"

@implementation AStarNode

@synthesize position;
@synthesize gScore;
@synthesize hScore;
@synthesize parent;


- (id)initWithPosition:(CGPoint)pos
{
	if ((self = [super init])) {
		position = pos;
		gScore = 0;
		hScore = 0;
		parent = nil;
	}
	return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@  pos=[%.0f;%.0f]  g=%d  h=%d  f=%d", [super description], self.position.x, self.position.y, self.gScore, self.hScore, [self fScore]];
}

- (BOOL)isEqual:(AStarNode *)otherNode
{
	return CGPointEqualToPoint(self.position, otherNode.position);
}

- (int)fScore
{
	return self.gScore + self.hScore;
}


@end