//
//  EREnemy.m
//  ch9-run
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "EREnemy.h"
#import "ERPlayfieldLayer.h"

@implementation EREnemy

@synthesize pf;
@synthesize fallSensor;
@synthesize isMovingRight;
@synthesize isFlying;
@synthesize shootTimer;

-(void) defineSensors {
    fallSensor = CGRectMake(self.boundingBox.origin.x + 20,
                            self.boundingBox.origin.y - 10,
                            self.boundingBox.size.width - 40,
                            10);
}

-(void) setPosition:(CGPoint)position {
    // Override set position so we can keep the sensors
    // together with sprite
    [super setPosition:position];
    
    [self defineSensors];
}

-(void) shoot {
    // Create a bullet at enemy's position
    ERBullet *bullet = [ERBullet spriteWithSpriteFrameName:IMG_BULLET];
    [bullet setColor:ccRED];
    [bullet setIsShootingRight:self.isMovingRight];
    [bullet setPosition:self.position];
    [bullet setIsHeroBullet:NO];

    // Tell the playfield to add the bullet
    [pf addBullet:bullet];
    
    // Play the sound effect
    [[SimpleAudioEngine sharedEngine] playEffect:SND_ENEMYSHOOT];
}

-(void) gotShot {
    CCParticleSystemQuad *emitter = [CCParticleSystemQuad particleWithFile:@"enemydie.plist"];
    [emitter setPosition:self.position];
    [pf addChild:emitter z:50];
    
    [self removeFromParentAndCleanup:YES];
    
    // Play the sound effect
    [[SimpleAudioEngine sharedEngine] playEffect:SND_ENEMYDEAD];
}

@end
