//
//  PhysicsSprite.h
//  ch7-pool
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "cocos2d.h"
#import "Box2D.h"

@interface PhysicsSprite : CCSprite
{
	b2Body *body_;
}
-(void) setPhysicsBody:(b2Body*)body;

@end