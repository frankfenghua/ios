//
//  OPControlTouch.mm
//  ch7-pool
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "OPControlOneTouch.h"
#import "OPPlayfieldLayer.h"

@implementation OPControlOneTouch

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    // Reject touches for now
    if (mp.isTouchBlocked) {
        return NO;
    }
    
    if (mp.isUserDismissMsg) {
        [mp dismissMessage];
        [mp setIsUserDismissMsg:NO];
        return YES;
    }
    
    // If game over splash is finished, next touch
    // returns to the menu
    if (mp.isGameOver) {
        [mp returnToMainMenu];
        return YES;
    }
    // Determine touch position
    CGPoint loc = [touch locationInView:[touch view]];
    CGPoint convLoc = [[CCDirector sharedDirector]
                       convertToGL:loc];
    // If there was a scratch, the cue is in hand
    if (mp.isBallInHand) {
        cueBallInHand = [CCSprite spriteWithSpriteFrameName:@"ball_0.png"];
        [cueBallInHand setPosition:convLoc];
        [mp addChild:cueBallInHand z:10];
        return YES;
    }
    // Check if the touch is on the table
    if (CGRectContainsPoint([[mp table] boundingBox], convLoc)) {
        // Store the point we are aiming at
        aimAtPoint = [mp getCueBallPos];
        
        // Update the cue position
        [self updateCueAimFromLoc:convLoc];
        return YES;
    }
    return NO;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    // Determine touch position
    CGPoint loc = [touch locationInView:[touch view]];
    CGPoint convLoc = [[CCDirector sharedDirector]
                       convertToGL:loc];
    
    // If there was a scratch, the cue is in hand
    if (mp.isBallInHand) {
        [cueBallInHand setPosition:convLoc];
        return;
    }
    [self updateCueAimFromLoc:convLoc];
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    // If there was a scratch, the cue is in hand
    if (mp.isBallInHand) {
        [mp createBall:kBallCue AtPos:[cueBallInHand position]];
        [cueBallInHand removeFromParentAndCleanup:YES];
        mp.isBallInHand = NO;
    }
    
    // Only make the shot of it is in the legal range
    if (shotLength > 75 || shotLength < 4) {
        // Reject the shot
    }
    else {
        // Take the shot
        [mp makeTheShot];
    }
}

@end
