//
//  OPControlTwoTouch.mm
//  ch7-pool
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "OPControlTwoTouch.h"
#import "OPPlayfieldLayer.h"

@implementation OPControlTwoTouch

-(id) init {
    if(self = [super init]) {
        shootButton = [CCLabelTTF labelWithString:@"Shoot!" fontName:@"Verdana" fontSize:20];
        [shootButton setAnchorPoint:ccp(0.5,0)];
        [shootButton setPosition:ccp(160,0)];
        [shootButton setVisible:NO];
        [self addChild:shootButton z:10];
    }
    return self;
}


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
    // If we are tracking the aim
    aimAtPoint = [mp getCueBallPos];
    // Check if the Shoot Button was touched
    if (CGRectContainsPoint([shootButton boundingBox], convLoc)) {
        [mp makeTheShot];
        return YES;
    }
    // Check if the touch is on the table
    if (CGRectContainsPoint([[mp table] boundingBox], convLoc)) {
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
    
    // If not ball in hand, control the cue
    [self updateCueAimFromLoc:convLoc];
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    // If there was a scratch, the cue is in hand
    if (mp.isBallInHand) {
        [mp createBall:kBallCue AtPos:[cueBallInHand position]];
        [cueBallInHand removeFromParentAndCleanup:YES];
        mp.isBallInHand = NO;
    }
}

@end
