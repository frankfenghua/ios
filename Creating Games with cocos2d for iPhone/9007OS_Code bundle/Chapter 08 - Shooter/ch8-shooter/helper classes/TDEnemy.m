//
//  TDEnemy.m
//  ch8-shooter
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "TDEnemy.h"
#import "TDPlayfieldLayer.h"

@implementation TDEnemy

@synthesize sprite;

+(id) enemyAtPos:(CGPoint)pos onLayer:(TDPlayfieldLayer*)layer {
    return [[[self alloc] initForEnemyAtPos:pos onLayer:layer] autorelease];
}

-(id) initForEnemyAtPos:(CGPoint)pos onLayer:(TDPlayfieldLayer*)layer  {
    if((self = [super init])) {
        // Keep a reference to the layer
        parentLayer = layer;

        // Build the sprite
        [self buildEnemySpriteAtPos:pos];
 
        // Add the sprite to the layer
        [parentLayer addChild:sprite z:2];
    
        // Set the max shooting speed
        maxShootSpeed = 3;
    }
    return self;
}

-(void) buildEnemySpriteAtPos:(CGPoint)pos {
    sprite = [CCSprite spriteWithSpriteFrameName:IMG_ENEMY];
    [sprite setPosition:pos];
}

-(void) moveToward:(CGPoint)target {
    // Rotate toward player
    [self rotateToTarget:target];

    // Move toward the player
    CGFloat targetAngle =
                CC_DEGREES_TO_RADIANS(-sprite.rotation);
    CGPoint targetPoint = ccpForAngle(targetAngle);
    CGPoint finalTarget = ccpAdd(targetPoint,
                                 sprite.position);
    CGPoint tileCoord = [parentLayer
                         tileCoordForPos:finalTarget];
    
    if ([parentLayer isWallAtTileCoord:tileCoord]) {
        // Cannot move - hit a wall
        return;
    }
    
    // Set the new position
    sprite.position = finalTarget;
}

-(void) rotateToTarget:(CGPoint)target {
    // Rotate toward player
    CGPoint diff = ccpSub(target,sprite.position);
    float angleRadians = atanf((float)diff.y / (float)diff.x);
    float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
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
    bullet.isEnemy = YES;
    [bullet setColor:ccRED];
    
    // add bullets to parentLayer's array
    [parentLayer addBullet:bullet];
    
    // Play a sound effect
    [[SimpleAudioEngine sharedEngine] playEffect:SND_SHOOT];
}

-(void) update:(ccTime)dt {
    
    currShootSpeed = currShootSpeed - dt;
    
    // take a step
    [self moveToward:[parentLayer getHeroPos]];
    
    if (ccpDistance(sprite.position, [parentLayer getHeroPos]) < 250) {
        // Limit the shoot speed
        if (currShootSpeed <= 0) {
            // Ready to shoot
            [self shoot];
            currShootSpeed = maxShootSpeed;
        }
    }
}

-(void) dealloc {
    [self unscheduleUpdate];

    parentLayer = nil;
    
    [super dealloc];
}

@end
