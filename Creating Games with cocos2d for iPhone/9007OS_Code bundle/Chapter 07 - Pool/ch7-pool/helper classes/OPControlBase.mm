//
//  OPControlBase.mm
//  ch7-pool
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "OPControlBase.h"
#import "OPPlayfieldLayer.h"

@implementation OPControlBase

@synthesize mp; // main playfield
@synthesize shotLength;
@synthesize plannedHit;
@synthesize aimAtPoint;

#pragma mark Touch Handler
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return NO;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    [self hideCue];
}

-(void) updateCueAimFromLoc:(CGPoint)convLoc {

    // Position the cue at the cue ball
    CGPoint offset = ccpSub(aimAtPoint,convLoc);
    CGPoint approach = ccpNormalize(offset);
    
    // Move the cue into the right angle
    [mp.poolcue setPosition:ccpSub(aimAtPoint, offset)];
    [mp.poolcue setVisible:YES];
    [mp.poolcue setRotation:
     (-1 * CC_RADIANS_TO_DEGREES(
                            ccpToAngle(approach))) + 90];
    
    // Calculate the power of the hit
    shotLength = sqrtf((offset.x* offset.x) +
                       (offset.y*offset.y)) - 4.5;
    
    // We limit how far away the cue can be
    if (shotLength > 75 || shotLength < 4) {
        // We reject this hit
        [self hideCue];
        return;
    } else {
        // Calculate the planned hit
        float hitPower = shotLength / 6;
        plannedHit = ccp(hitPower * approach.x,
                         hitPower * approach.y);
        mp.isHitReady = YES;
        shootButton.visible = YES;
    }
}

-(void) hideCue {
    // Hide the pool cue
    [mp.poolcue setPosition:CGPointZero];
    [mp.poolcue setVisible:NO];
    [mp.poolcue setOpacity:255];
    
    // There is not a valid hit
    // Reset all hit vars
    mp.isHitReady = NO;
    plannedHit = CGPointZero;
    shotLength = 0;
    
    // Hide the shoot button
    shootButton.visible = NO;
}

#pragma mark Enter, Exit, and Dealloc
-(void)onEnter
{
    [super onEnter];
    
    [[[CCDirector sharedDirector] touchDispatcher]
     addTargetedDelegate:self
     priority:0
     swallowsTouches:NO];
}

-(void)onExit
{
    [[[CCDirector sharedDirector] touchDispatcher]
     removeDelegate:self];
    
    [super onExit];
}

-(void) dealloc {
    
    [super dealloc];
}

@end
