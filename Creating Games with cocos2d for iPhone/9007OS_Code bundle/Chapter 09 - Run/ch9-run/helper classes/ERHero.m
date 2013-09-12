//
//  ERHero.m
//  ch9-run
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "ERHero.h"
#import "ERPlayfieldLayer.h"

@implementation ERHero

@synthesize state = _state;
@synthesize pf;
@synthesize footSensor;
@synthesize fallSensor;

+(id)spriteWithSpriteFrameName:(NSString *)spriteFrameName {
    return [[[self alloc] initWithSpriteFrameName:spriteFrameName] autorelease];
}

-(id) initWithSpriteFrameName:(NSString *)spriteFrameName {
    if(self = [super initWithSpriteFrameName:spriteFrameName]) {
     
        _state = kHeroFalling;
        
        // Let the hero take 5 hits before death
        heroHealth = 5;

    }
    return self;
}

-(void) stateChangeTo:(HeroState)newState {
    // Make sure we are actually changing state
    if (newState == _state) {
        return;
    }
    
    // Stop old actions
    [self stopAllActions];
    
    // Reset the color if we were flashing
    if (isFlashing) {
        CCTintTo *normal = [CCTintTo actionWithDuration:
                            0.05 red:255 green:255
                                                   blue:255];
        CCCallBlock *done = [CCCallBlock actionWithBlock:^{
            isFlashing = NO;
        }];
        
        [self runAction:[CCSequence actions:normal,
                         done,nil]];
    }
    
    // Determine what to do now
    switch (newState) {
        case kHeroRunning:
            [self playRunAnim];
            break;
        case kHeroJumping:
            [self playJumpAnim];
            break;
        case kHeroFalling:
            [self playLandAnim];
            break;
        case kHeroInAir:
            // Leave the last frame
            break;
    }
    _state = newState;
    
    [self defineSensors];
}


#pragma mark Sensors
-(void) defineSensors {
    
    footSensor = CGRectMake(self.boundingBox.origin.x + 20,
                              self.boundingBox.origin.y,
                              self.boundingBox.size.width - 40,
                              1);
    
    fallSensor = CGRectMake(self.boundingBox.origin.x + 20,
                              self.boundingBox.origin.y - 3,
                              self.boundingBox.size.width - 40,
                              2);
}


-(void) setPosition:(CGPoint)position {
    // Override set position so we can keep the sensors
    // together with sprite
    [super setPosition:position];
    
    [self defineSensors];
}


-(void) shoot {
    // Create a bullet at hero's position
    ERBullet *bullet = [ERBullet spriteWithSpriteFrameName:IMG_BULLET];
    [bullet setColor:ccBLUE];
    [bullet setIsShootingRight:YES];
    [bullet setIsHeroBullet:YES];
    [bullet setPosition:self.position];

    // Tell the playfield to add the bullet
    [pf addBullet:bullet];
    
    // Play the sound effect
    [[SimpleAudioEngine sharedEngine] playEffect:SND_HEROSHOOT];
}

-(void) gotShot {
    // Subtract one from hero health
    heroHealth--;
    
    // Determine if the hero is dead
    if (heroHealth <= 0) {
        // Spawn a death particle
        CCParticleSystemQuad *emitter = [CCParticleSystemQuad particleWithFile:@"ExplodingRing.plist"];
        [emitter setPosition:self.position];
        [pf addChild:emitter z:50];
        
        // We don't clean up to avoid block failure
        [self removeFromParentAndCleanup:NO];
        
        // Play the sound effect for death
        [[SimpleAudioEngine sharedEngine] playEffect:SND_HERODEATH];
        
        // Trigger game over
        [pf gameOver];
    } else if (isFlashing == NO) {
        // Flash the hero red briefly
        isFlashing = YES;
        CCTintTo *red = [CCTintTo actionWithDuration:0.05 red:255 green:0 blue:0];
        CCTintTo *normal = [CCTintTo actionWithDuration:0.05 red:255 green:255 blue:255];
        CCCallBlock *done = [CCCallBlock actionWithBlock:^{
            isFlashing = NO;
        }];
        [self runAction:[CCSequence actions: red, normal, done, nil]];
        
        // Play the got hit sound effect
        [[SimpleAudioEngine sharedEngine] playEffect:SND_HEROHIT];
    }
}

#pragma mark Animation Calls
-(void) playRunAnim {
    CCAnimate *idle = [pf getAnim:@"HeroRun"];
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:idle];
    [self runAction:repeat];
}

-(void) playJumpAnim {
    CCAnimate *jump = [pf getAnim:@"HeroJump"];
    CCCallBlock *change = [CCCallBlock actionWithBlock:^{
        [self stateChangeTo:kHeroInAir];
    }];
    CCSequence *doIt = [CCSequence actions:jump, change, nil];
    
    [self runAction:doIt];
    
    // Play the sound effect
    [[SimpleAudioEngine sharedEngine] playEffect:SND_HEROJUMP];
}

-(void) playLandAnim {
    CCAnimate *land = [pf getAnim:@"HeroLand"];
    [self runAction:land];
}
  

#pragma mark Animation Loaders
-(void) loadAnimations {
    [pf buildCacheAnimation:@"HeroRun"
           forFrameNameRoot:@"hero_run"
              withExtension:@".png"
                 frameCount:4 withDelay:0.1];
    [pf buildCacheAnimation:@"HeroJump"
           forFrameNameRoot:@"hero_jump"
              withExtension:@".png"
                 frameCount:3 withDelay:0.1];
    [pf buildCacheAnimation:@"HeroLand"
           forFrameNameRoot:@"hero_land"
              withExtension:@".png"
                 frameCount:3 withDelay:0.1];
}



@end
