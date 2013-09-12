//
//  CLButton.m
//  ch6-cycles
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "CLButton.h"
#import "CLDefinitions.h"
#import "CLPlayfieldLayer.h"

@implementation CLButton

#pragma mark Initialization
+(id) buttonForBike:(CLBike*)thisBike 
         asPlayerNo:(NSInteger)playerNo 
             isLeft:(BOOL)isLeftButton
            onLayer:(CLPlayfieldLayer*)thisLayer {
    return [[[self alloc] initForBike:thisBike 
                           asPlayerNo:playerNo 
                               isLeft:isLeftButton
                              onLayer:thisLayer] 
            autorelease];   
}

-(id) initForBike:(CLBike*)thisBike 
       asPlayerNo:(NSInteger)playerNo 
           isLeft:(BOOL)isLeftButton
            onLayer:(CLPlayfieldLayer*)thisLayer {   
    if( self = [super initWithSpriteFrameName:IMG_BUTTON]) {

        // Store whether this is a left button
        isLeft = isLeftButton;

        // Keep track fo the parent bike
        parentBike = thisBike;

        // Keep track of the parent layer
        myPlayfield = thisLayer;
        
        // Set the tint of the button
        [self setColor:parentBike.wallColor];

        // Base values for positioning
        float newY = 30;
        float newX = [[CCDirector sharedDirector] 
                      winSize].width / 4;
        
        // Selective logic to position the buttons
        switch (playerNo) {
            case 1:
                if (isLeft) {
                    // Flip the image so it points left
                    [self setFlipX:YES];
                } else {
                    // Move it to the right
                    newX *= 3;
                } 
                break;
            case 2:
                // Player 2 is upside down at the top
                newY = 994;

                // Flip the buttons to face player
                [self setFlipY:YES];

                if (isLeft) {
                    // Move it to the right
                    newX *= 3;
                } else {
                    // Flip the image so it points left
                    [self setFlipX:YES];
                }
                break;
        }
 
        [self setPosition:ccp(newX, newY)];
        
    }
    return self;
}

#pragma mark Touch Handler
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
 
    // Prevent touches if the layer is not accepting
    // touches
    if (myPlayfield.isTouchBlocked) {
        return NO;
    }
    
    CGPoint loc = [touch locationInView:[touch view]];
    CGPoint convLoc = [[CCDirector sharedDirector]
                       convertToGL:loc];
    
    // Create an expanded hit box for this class
    CGRect hitRect = CGRectInset(self.boundingBox, 0, -50.0);
    
    // If touched, send a turn msg to the parent bike
    if (CGRectContainsPoint(hitRect, convLoc)) {
        if (isLeft) {
            [self flashButton];
            [parentBike turnLeft];
        } else {
            [self flashButton];
            [parentBike turnRight];
        }
    }

    return YES;
}

-(void)onEnter
{
    [[[CCDirector sharedDirector] touchDispatcher] 
     addTargetedDelegate:self 
     priority:0 
     swallowsTouches:NO];
    
    [super onEnter];
}

-(void)onExit
{
    parentBike = nil;
    myPlayfield = nil;
    
    [[[CCDirector sharedDirector] touchDispatcher] 
     removeDelegate:self];
    
    [super onExit];
}

#pragma mark Visual Effects
-(void) flashButton {
    // Tint to the original white color
    CCTintTo *tintA = [CCTintTo actionWithDuration:0.1
                                               red:255 
                                             green:255 
                                              blue:255];
    // Tint back to the original color
    CCCallBlock *tintB = [CCCallBlock actionWithBlock:
                ^{[self setColor:parentBike.wallColor];}];
    
    // Run these two actions in sequence
    [self runAction:[CCSequence actions: tintA, 
                     tintB, nil]];
}

@end
