//
//  ERHUDLayer.m
//  ch9-run
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "ERHUDLayer.h"

@implementation ERHUDLayer

-(id) init {
    if(self = [super init]) {
        [self addDisplay];
    }
    return self;
}

-(void) addDisplay {
    // Add the fixed text of the HUD
    CCLabelTTF *dist = [CCLabelTTF labelWithString:@"Distance:" fontName:@"Verdana" fontSize:16];
    [dist setAnchorPoint:ccp(0,0.5)];
    [dist setPosition:ccp(10,305)];
    [dist setColor:ccRED];
    [self addChild:dist];
    
    // Add the distance counter
    lblDistance = [CCLabelTTF labelWithString:@"0.0" fontName:@"Verdana" fontSize:16];
    [lblDistance setAnchorPoint:ccp(0,0.5)];
    [lblDistance setPosition:ccp(120,305)];
    [lblDistance setColor:ccBLUE];
    [self addChild:lblDistance];

}

-(void) changeDistanceTo:(float)newDistance {
    NSString *newVal = [NSString stringWithFormat:@"%0.2f", newDistance];
    
    [lblDistance setString:newVal];
}

-(void) showGameOver:(NSString*)msg {
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    CCLabelTTF *gameOver = [CCLabelTTF labelWithString:msg fontName:@"Verdana" fontSize:30];
    [gameOver setColor:ccRED];
    [gameOver setPosition:ccp(size.width/2, size.height/2)];
    [self addChild:gameOver z:50];

}


@end
