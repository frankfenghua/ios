//
//  TDHero.m
//  ch8-shooter
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "TDHero.h"
#import "TDPlayfieldLayer.h"

@implementation TDHero

@synthesize sprite;

+(id) heroAtPos:(CGPoint)pos onLayer:(TDPlayfieldLayer*)layer {
    return [[[self alloc] initForHeroAtPos:pos onLayer:layer] autorelease];
}

-(id) initForHeroAtPos:(CGPoint)pos onLayer:(TDPlayfieldLayer*)layer  {
    if((self = [super init])) {
        
        // Keep a reference to the layer
        parentLayer = layer;
        
        // Build the sprite
        self.sprite = [CCSprite
                    spriteWithSpriteFrameName:IMG_HERO];
        [sprite setPosition:pos];
        
        // Add the sprite to the layer
        [parentLayer addChild:sprite z:2];
    }
    return self;
}

-(void) rotateToTarget:(CGPoint)target {
    // Rotate toward player
    CGPoint diff = ccpSub(target,sprite.position);
    float angleRadians = atanf((float)diff.y /
                               (float)diff.x);
    float angleDegrees=CC_RADIANS_TO_DEGREES(angleRadians);
    float cocosAngle = -angleDegrees;
    if (diff.x < 0) {
        cocosAngle += 180;
    }
    sprite.rotation = cocosAngle;
}

-(void) shoot {
    // Create a projectile at hero's position
    TDBullet *bullet = [TDBullet bulletFactoryForLayer:parentLayer];
    bullet.position = self.sprite.position;
    bullet.rotation = self.sprite.rotation;
    bullet.isEnemy = NO;
    
    // add bullets to parentLayer's array
    [parentLayer addBullet:bullet];

    // Play a sound effect
    [[SimpleAudioEngine sharedEngine] playEffect:SND_SHOOT];
}

-(void) dealloc {
    [self unscheduleUpdate];
    
    parentLayer = nil;
    
    [super dealloc];
}

@end
