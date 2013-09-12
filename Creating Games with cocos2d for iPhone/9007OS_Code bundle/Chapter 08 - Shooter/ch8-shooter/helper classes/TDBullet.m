//
//  TDBullet.m
//  ch8-shooter
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "TDBullet.h"
#import "TDPlayfieldLayer.h"

@implementation TDBullet

@synthesize isDead;
@synthesize isEnemy;

+(id) bulletFactoryForLayer:(TDPlayfieldLayer*)layer {
    return [[[self alloc] initForLayer:layer withSpriteFrameName:IMG_BULLET] autorelease];
}

-(id) initForLayer:(TDPlayfieldLayer*)layer withSpriteFrameName:(NSString*)spriteFrameName {
    if((self = [super initWithSpriteFrameName:spriteFrameName])) {

        parentLayer = layer;
        
        totalMoveDist = 200;
        thisMoveDist = 10;
        
        isDead = NO;
        
    }
    return self;
}

-(void) update:(ccTime)dt {
    if (isDead) {
        return;
    }
    // Calculate the movement
    CGFloat targetAngle =
            CC_DEGREES_TO_RADIANS(-self.rotation);
    CGPoint targetPoint = ccpMult(ccpForAngle(targetAngle),
                                  thisMoveDist);
    CGPoint finalTarget = ccpAdd(targetPoint, self.position);

    self.position = finalTarget;

    totalMoveDist = totalMoveDist - thisMoveDist;

    if (totalMoveDist <= 0) {
        [parentLayer removeBullet:self];
        return;
    }
    
    // Convert location to tile coords
    CGPoint tileCoord = [parentLayer tileCoordForPos:
                         self.position];
    
    // Check for walls.  Walls stop bullets.
    if ([parentLayer isWallAtTileCoord:tileCoord]) {
        [parentLayer removeBullet:self];
    }
}

-(void) dealloc {

    parentLayer = nil;
    
    [super dealloc];
}
@end
