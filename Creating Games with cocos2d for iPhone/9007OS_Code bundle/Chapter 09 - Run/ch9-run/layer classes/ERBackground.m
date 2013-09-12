//
//  ERBackground.m
//  ch9-run
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "ERBackground.h"


@implementation ERBackground

@synthesize bgScrollSpeed;
@synthesize initialOffset;

-(id) init {
    if(self = [super init]) {
        
        size = [[CCDirector sharedDirector] winSize];
        
        bg1 = [CCSprite spriteWithFile:@"bg_mtns.png"];
        [bg1 setAnchorPoint:ccp(0,0)];
        [bg1 setPosition:ccp(0, 0)];
        [self addChild:bg1];

        bg2 = [CCSprite spriteWithFile:@"bg_mtns.png"];
        [bg2 setAnchorPoint:ccp(0,0)];
        [bg2 setPosition:ccp(1001, 0)];
        [self addChild:bg2];
        
        [bg2 setFlipX:YES];
    }
    return self;
}

-(void) useDarkBG {
    // Tint for darker mountains
    [bg1 setColor:ccc3(150,150,150)];
    [bg2 setColor:ccc3(150,150,150)];
}

-(void) update:(ccTime)dt {
    
    // Move the mountains by their scroll speed
    [bg1 setPosition:ccpAdd(bg1.position,
                            ccp(-bgScrollSpeed,0))];
    [bg2 setPosition:ccpAdd(bg2.position,
                            ccp(-bgScrollSpeed,0))];
    
    // If bg1 is completely off-screen, move after bg2
    if (bg1.position.x < (-1000 - initialOffset.x)) {
        [bg1 setPosition:ccpAdd(bg2.position,
                        ccp(1000 + initialOffset.x,0))];
    }
    
    // If bg2 is completely off-screen, move after bg1
    if (bg2.position.x < (-1000 - initialOffset.x)) {
        [bg2 setPosition:ccpAdd(bg1.position,
                        ccp(1000 + initialOffset.x,0))];
    }
}


@end
