//
//  MXMole.m
//  ch3-moles
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "MXMole.h"

@implementation MXMole

@synthesize parentHill;
@synthesize moleSprite;
@synthesize moleGroundY;
@synthesize moleState = _moleState;
@synthesize isSpecial;

-(id) init {
    if(self = [super init]) {
            self.moleState = kMoleDead;
            [[[CCDirector sharedDirector] touchDispatcher]
                    addTargetedDelegate:self priority:0
                    swallowsTouches:NO];
    }
	return self;	
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:[touch view]];
    CGPoint convLoc = [[CCDirector sharedDirector]
                       convertToGL:location];
    
    if (self.moleState == kMoleDead) {
        return NO;
    } else if (self.moleSprite.position.y +
               (self.moleSprite.contentSize.height/2)
               <= moleGroundY) {
		self.moleState = kMoleHidden;
		return NO;
	} else  {
        // Verify touch was on this mole and above ground
        if (CGRectContainsPoint(self.moleSprite.boundingBox,
                                convLoc) &&
            convLoc.y >= moleGroundY)
        {
            // Set the mole's state
            self.moleState = kMoleHit;
            
            // Play the "hit" sound
            if (isSpecial) {
                [[SimpleAudioEngine sharedEngine]
                        playEffect:SND_MOLE_SPECIAL];
            } else {
                [[SimpleAudioEngine sharedEngine]
                        playEffect:SND_MOLE_NORMAL];
            }
        }
        return YES;
    }
}

-(void) destroyTouchDelegate {
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}

@end
