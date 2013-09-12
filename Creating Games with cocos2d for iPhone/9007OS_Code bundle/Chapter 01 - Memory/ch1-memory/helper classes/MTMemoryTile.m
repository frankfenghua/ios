//
//  MTMemoryTile.m
//  ch1-memory
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "MTMemoryTile.h"

#define SND_TILE_FLIP @"button.caf"

@implementation MTMemoryTile

@synthesize tileRow = _tileRow;
@synthesize tileColumn = _tileColumn;
@synthesize faceSpriteName = _faceSpriteName;
@synthesize isFaceUp;

-(void) dealloc {
    // We set this to nil to let the string go away
    self.faceSpriteName = nil;
    
    [super dealloc];
}

-(void) showFace {
    // Instantly swap the texture used for this tile
    // to the faceSpriteName 
    [self setDisplayFrame:[[CCSpriteFrameCache
                            sharedSpriteFrameCache]
                spriteFrameByName:self.faceSpriteName]];
    
    self.isFaceUp = YES;
}

-(void) showBack {
    // Instantly swap the texture to the back image
    [self setDisplayFrame:[[CCSpriteFrameCache
                            sharedSpriteFrameCache]
                spriteFrameByName:@"tileback.png"]];
    
    self.isFaceUp = NO;
}

-(void) changeTile {
    // This is called in the middle of the flipTile
    // method to change the tile image while the tile is
    // "on edge", so the player doesn't see the switch
    if (isFaceUp) {
        [self showBack];
    } else {
        [self showFace];
    }
}

-(void) flipTile {
    // This method uses the CCOrbitCamera to spin the
    // view of this sprite so we simulate a tile flip
    
    // Duration is how long the total flip will last
    float duration = 0.25f;
    
    CCOrbitCamera *rotateToEdge = [CCOrbitCamera
                actionWithDuration:duration/2 radius:1
                deltaRadius:0 angleZ:0 deltaAngleZ:90
                angleX:0 deltaAngleX:0];
    CCOrbitCamera *rotateFlat = [CCOrbitCamera
                actionWithDuration:duration/2 radius:1
                deltaRadius:0 angleZ:270 deltaAngleZ:90
                angleX:0 deltaAngleX:0];
    [self runAction:[CCSequence actions: rotateToEdge,
                      [CCCallFunc actionWithTarget:self
                      selector:@selector(changeTile)],
                      rotateFlat, nil]];

    // Play the sound effect for flipping
    [[SimpleAudioEngine sharedEngine] playEffect:
                                    SND_TILE_FLIP];
}

- (BOOL)containsTouchLocation:(CGPoint)pos
{
    // This is called from the CCLayer to let the object
    // answer if it was touched or not
	return CGRectContainsPoint(self.boundingBox, pos);
}

@end
