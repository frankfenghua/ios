//
//  TDControlLayer.m
//  ch8-shooter
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "TDControlLayer.h"
#import "TDPlayfieldLayer.h"
#import "TDMenuScene.h"

@implementation TDControlLayer

+(id) controlsWithPlayfieldLayer:(TDPlayfieldLayer*)playfieldLayer withTilt:(BOOL)isTilt {
    return [[[self alloc] initWithPlayfieldLayer:playfieldLayer withTilt:isTilt] autorelease];
}

-(id) initWithPlayfieldLayer:(TDPlayfieldLayer*)playfieldLayer withTilt:(BOOL)isTilt {
    if(self = [super init]) {

        pf = playfieldLayer;
        
        isTiltControl = isTilt;
        
        if (isTiltControl) {
            // Set up the tilt controls
            [self addTiltControl];
        } else {
            // Set up the joystick
            [self addJoystick];
        }
        
        // Add the fire button (all modes)
        [self addFireButton];
        
        [self scheduleUpdate];
    }
    return self;
}

-(void) addTiltControl {
    // Set up the accelerometer
    self.isAccelerometerEnabled = YES;

    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0 / 60];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    // Accelerometer values based on portrait mode, so
    // we reverse them for landscape
    accelX = acceleration.y * 7;
    accelY = -acceleration.x * 7;
}

-(void) addJoystick {
    SneakyJoystickSkinnedBase *leftJoy =
            [[[SneakyJoystickSkinnedBase alloc] init]
             autorelease];
    leftJoy.backgroundSprite = [ColoredCircleSprite
       circleWithColor:ccc4(255, 255, 0, 128) radius:32];
    leftJoy.thumbSprite = [ColoredCircleSprite
       circleWithColor:ccc4(0, 0, 255, 200) radius:16];
    leftJoy.joystick = [[[SneakyJoystick alloc]
       initWithRect:CGRectMake(0,0,64,64)] autorelease];
    leftJoystick = leftJoy.joystick;
    leftJoy.position = ccp(64,36);
    [self addChild:leftJoy z:30];
}

-(void) addFireButton {
    SneakyButtonSkinnedBase *rightBut =
            [[[SneakyButtonSkinnedBase alloc] init]
             autorelease];
    rightBut.position = ccp(420,36);
    rightBut.defaultSprite = [ColoredCircleSprite
      circleWithColor:ccc4(255, 255, 255, 128) radius:32];
    rightBut.activatedSprite = [ColoredCircleSprite
      circleWithColor:ccc4(255, 255, 255, 255) radius:32];
    rightBut.pressSprite = [ColoredCircleSprite
      circleWithColor:ccc4(255, 0, 0, 255) radius:32];
    rightBut.button = [[[SneakyButton alloc]
      initWithRect:CGRectMake(0, 0, 64, 64)] autorelease];
    rightButton = rightBut.button;
    rightButton.isToggleable = YES;
    [self addChild:rightBut];
}

-(void)update:(ccTime)delta {
    
    // Do nothing if the touches are off
    if ([pf preventTouches]) {
        return;
    }

    if ([pf isGameOver]) {
        [[CCDirector sharedDirector] replaceScene:
                                [TDMenuScene node]];
    }
    
    if (isTiltControl) {
        // Tilt code here
        CGPoint heroPos = [pf getHeroPos];
        CGPoint newHeroPos = ccp(heroPos.x + accelX,
                                 heroPos.y + accelY);
        
        [pf rotateHeroToward:newHeroPos];
        [pf setHeroPos:newHeroPos];

    } else {
        // If the stick isn't centered, then we're moving
        if (CGPointEqualToPoint(leftJoystick.stickPosition,
                                CGPointZero) == NO) {
            // Pass the call to the playfield
            [pf applyJoystick:leftJoystick
                         toNode:pf.hero.sprite
                   forTimeDelta:delta];
        }
    }
    // If the button is active, let the playfield know
    if (rightButton.active) {
        [pf setHeroShooting:YES];
    } else {
        [pf setHeroShooting:NO];
    }
}

-(void) dealloc {
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
    
    [super dealloc];
}

@end
