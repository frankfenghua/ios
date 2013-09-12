//
//  CLBike.m
//  ch6-cycles
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "CLBike.h"
#import "CLPlayfieldLayer.h"
#import "SimpleAudioEngine.h"

@implementation CLBike

@synthesize thisPlayerID = _thisPlayerID;
@synthesize bikeSpeed = _bikeSpeed;
@synthesize bikeDirection = _bikeDirection;
@synthesize wallColor = _wallColor;
@synthesize currentWall = _currentWall;
@synthesize priorWall = _priorWall;
@synthesize isRemotePlayer;
@synthesize isCrashed;

+(id) bikeForPlayer:(PlayerID)playerID 
           PlayerNo:(NSInteger)playerNo 
            onLayer:(CLPlayfieldLayer*)thisLayer
           isRemote:(BOOL)remotePlayer
{
    return [[[self alloc] initForPlayer:playerID 
                               PlayerNo:playerNo 
                                onLayer:thisLayer
                               isRemote:remotePlayer] 
            autorelease];   
}

-(id) initForPlayer:(PlayerID)playerID 
           PlayerNo:(NSInteger)playerNo 
            onLayer:(CLPlayfieldLayer*)thisLayer
           isRemote:(BOOL)remotePlayer {
    if(self = [super initWithSpriteFrameName:IMG_BIKE]) {
        myPlayfield = thisLayer;
        
        isRemotePlayer = remotePlayer;
        
        size = [[CCDirector sharedDirector] winSize];
        
        self.thisPlayerID = playerID;
        self.bikeSpeed = 3.0;
        self.bikeDirection = kUp;
        self.anchorPoint = ccp(0.5,0);
        self.scale = 0.25;
        self.isCrashed = NO;
        
        // Set the player's wall color
        switch (self.thisPlayerID) {
            case kRedPlayer:
                self.wallColor = ccc3(255, 75, 75);
                break;
            case kBluePlayer:
                self.wallColor = ccc3(75, 75, 255);
                break;
        }

        switch (playerNo) {
            case 1:
                // Starts at bottom of screen
                [self setPosition:ccp(size.width/2,64)];
                break;
            case 2:
                // Starts at top of screen
                [self setPosition:ccp(size.width/2,960)];
                self.bikeDirection = kDown;
                break;
        }
        
        [self rotateBike];
        
        glow = [CCSprite spriteWithSpriteFrameName:IMG_GLOW];
        [glow setAnchorPoint:[self anchorPoint]];
        [glow setPosition:ccp(34,26)];
        [glow setColor:self.wallColor];
        [self addChild:glow z:-1];

        // Bike's wall init here
        wallWidth = 5;
        
        self.priorWall = nil;
        self.currentWall = [myPlayfield 
                            createWallFromBike:self];
    }
    return self;
}

-(void)moveForDistance:(float)dist {
    // Updates the bike's current position
    // And scales the currentWall correctly
    switch (self.bikeDirection) {
        case kUp:
            [self setPosition:ccp(self.position.x,
                                  self.position.y + 
                                  dist)];
            
            [self.currentWall setScaleY:
             ABS(self.currentWall.position.y - 
                 self.position.y)];
            
            [self.currentWall setScaleX:wallWidth];
            
            break;
        case kDown:
            [self setPosition:ccp(self.position.x,
                                  self.position.y - 
                                  dist)];
            
            [self.currentWall setScaleY:
             ABS(self.currentWall.position.y
                 - self.position.y)];
            
            [self.currentWall setScaleX:wallWidth];
            
            break;
        case kLeft:
            [self setPosition:ccp(self.position.x - 
                                  dist,
                                  self.position.y)];
            
            [self.currentWall setScaleX:
             ABS(self.currentWall.position.x 
                 - self.position.x)];
            
            [self.currentWall setScaleY:wallWidth];
            
            break;
        case kRight:
            [self setPosition:ccp(self.position.x + 
                                  dist,
                                  self.position.y)];
            
            [self.currentWall setScaleX:
             ABS(self.currentWall.position.x 
                 - self.position.x)];
            
            [self.currentWall setScaleY:wallWidth];
            
            break;
        default:
            break;
    }
}

-(void) move {
    // Move this bike (if local player)
    [self moveForDistance:self.bikeSpeed];
    
    // Remote game
    [self sendPacketForMove:self.bikeSpeed];
}

-(void) turnRight {
    // Turn the bike to the right
    switch (self.bikeDirection) {
        case kUp:
            self.bikeDirection = kRight;
            break;
        case kRight:
            self.bikeDirection = kDown;
            break;
        case kDown:
            self.bikeDirection = kLeft;
            break;
        case kLeft:
            self.bikeDirection = kUp;
            break;
        default:
            break;
    }
    
    // Rotate the bike to the new direction
    [self rotateBike];
    
    // Play the turn sound
    [[SimpleAudioEngine sharedEngine] playEffect:SND_TURN];
    
    // Wall assignments
    self.priorWall = self.currentWall;
    self.currentWall = [myPlayfield 
                        createWallFromBike:self];
    
    // Remote game
    [self sendPacketForTurn:kRight];
}

-(void)turnLeft {
    // Turn the bike left
    switch (self.bikeDirection) {
        case kUp:
            self.bikeDirection = kLeft;
            break;
        case kLeft:
            self.bikeDirection = kDown;
            break;
        case kDown:
            self.bikeDirection = kRight;
            break;
        case kRight:
            self.bikeDirection = kUp;
            break;
        default:
            break;
    }
    
    // Rotate the bike to the new direction
    [self rotateBike];
    
    // Play the turn sound
    [[SimpleAudioEngine sharedEngine] playEffect:SND_TURN];
    
    // Wall assignments
    self.priorWall = self.currentWall;
    self.currentWall = [myPlayfield 
                        createWallFromBike:self];

    // Remote game
    [self sendPacketForTurn:kLeft];
}

-(CGPoint) wallAnchorPoint {
    // Calculate the anchor point, based on direction
    switch (self.bikeDirection) {
        case kUp:
            return ccp(0.5,0);
            break;
        case kRight:
            return ccp(0,0.5);
            break;
        case kDown:
            return ccp(0.5,1);
            break;
        case kLeft:
            return ccp(1,0.5);
            break;
        default:
            return ccp(0.5,0.5);
            break;
    }
}

-(void) rotateBike {
    // Rotate the bike to match the direction
    switch (self.bikeDirection) {
        case kUp:
            self.rotation = 0;
            break;
        case kRight:
            self.rotation = 90;
            break;
        case kDown:
            self.rotation = 180;
            break;
        case kLeft:
            self.rotation = -90;
            break;
        default:
            break;
    }
}


-(void) sendPacketForTurn:(Direction)turnDir {
    // We only send a packet if we are playing a remote
    // game, and this bike is the LOCAL player
    if (myPlayfield.remoteGame && self.isRemotePlayer == NO) {
        [myPlayfield sendDataWithDirection:turnDir
                                orDistance:0];
    }
}

-(void) sendPacketForMove:(float)distance {
    // We only send a packet if we are playing a remote
    // game, and this bike is the LOCAL player
    if (myPlayfield.remoteGame && self.isRemotePlayer == NO) {
        [myPlayfield sendDataWithDirection:kNoChange
                                orDistance:distance];
    }
}

#pragma mark Wall Handlers

-(void) crash {
    self.isCrashed = YES;
    
    [glow removeFromParentAndCleanup:NO];
    
    CCScaleTo *scale = [CCScaleTo actionWithDuration:0.5
                                               scale:2];
    CCFadeOut *fade = [CCFadeOut actionWithDuration:1.0];
    
    [self runAction:[CCSequence actions:scale, fade, nil]];
}

@end
