//
//  SNMouse.m
//  ch4-snake
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "SNMouse.h"


@implementation SNMouse

@synthesize lifespan;

+(id) spriteWithSpriteFrameName:(NSString *)spriteFrameName {
    return [[[self alloc] initWithSpriteFrameName:
             spriteFrameName] autorelease];
}

-(id) initWithSpriteFrameName:(NSString*)spriteFrameName {
    if (self = [super initWithSpriteFrameName:spriteFrameName]) {
        // Lifespan is between 10 and 20
        lifespan = 10 + (CCRANDOM_0_1() * 10);
    }
    return self;
}

@end
