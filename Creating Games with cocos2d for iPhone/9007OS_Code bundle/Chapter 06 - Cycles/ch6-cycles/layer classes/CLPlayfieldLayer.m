//
//  CLPlayfieldLayer.m
//  ch6-cycles
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "CLPlayfieldLayer.h"
#import "CLPlayfieldScene.h"
#import "CLMenuScene.h"
#import "CLRenderGrid.h"

@implementation CLPlayfieldLayer

@synthesize cyclesheet;
@synthesize remoteGame;
@synthesize isTouchBlocked;

+(id) gameWithRemoteGame:(BOOL)isRemoteGame {
    return [[[self alloc] initWithRemoteGame:isRemoteGame] autorelease];
}

-(id) initWithRemoteGame:(BOOL)isRemoteGame {
    if(self = [super init]) {

        size = [[CCDirector sharedDirector] winSize];
        
        // Load the spritesheet
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"cyclesheet.plist"];
        cyclesheet = [CCSpriteBatchNode batchNodeWithFile:@"cyclesheet.png"];
        
        // Add the batch node to the layer
        [self addChild:cyclesheet z:1];
        
        bikeWalls = [[NSMutableArray alloc] init];
        remoteGame = isRemoteGame;
        isGameOver = NO;
        isTouchBlocked = NO;

        // Build the background grid
        CCNode *grid = [CLRenderGrid node];
        [self addChild:grid z:-1];
        
        // Build the outer walls
        [self createOuterWalls];
        
    }
    return self;
}

-(void) onEnterTransitionDidFinish {
    if (remoteGame) {
        // Remote Game
        [self findPeer:self];
    } else {
        // Initial Player Setup
        [self generateRedAsPlayerNo:1 isRemote:NO];
        [self generateBlueAsPlayerNo:2 isRemote:NO];
        [self scheduleUpdate]; 
    }
    [super onEnterTransitionDidFinish];
}

#pragma mark Update Loop
-(void) update:(ccTime)dt {

    // We only use the move method if this is a local
    // player.  We move the opponent via the data 
    // connection
    if (![redBike isRemotePlayer]) {
        [redBike move];
    }

    if (![blueBike isRemotePlayer]) {
        [blueBike move];
    }

    [self checkForCollisions];
}

#pragma mark Generate Players
-(void) generateRedAsPlayerNo:(NSInteger)playerNo
                     isRemote:(BOOL)remotePlayer {
    // Generate the red player's bike
    redBike = [CLBike bikeForPlayer:kRedPlayer 
                           PlayerNo:playerNo 
                            onLayer:self 
                           isRemote:remotePlayer];
    [cyclesheet addChild:redBike];
    
    // Only create buttons for the local player
    if (remotePlayer == NO) {
        
        CLButton *right = [CLButton 
                           buttonForBike:redBike
                           asPlayerNo:playerNo
                           isLeft:NO 
                           onLayer:self];
        [cyclesheet addChild:right];
        
        CLButton *left = [CLButton 
                          buttonForBike:redBike
                          asPlayerNo:playerNo
                          isLeft:YES
                          onLayer:self];
        [cyclesheet addChild:left];
    }
}

-(void) generateBlueAsPlayerNo:(NSInteger)playerNo
                      isRemote:(BOOL)remotePlayer {
    // Generate the red player's bike
    blueBike = [CLBike bikeForPlayer:kBluePlayer 
                            PlayerNo:playerNo 
                             onLayer:self 
                            isRemote:remotePlayer];
    [cyclesheet addChild:blueBike];
    
    // Only create buttons for the local player
    if (remotePlayer == NO) {
        CLButton *right = [CLButton 
                           buttonForBike:blueBike 
                           asPlayerNo:playerNo 
                           isLeft:NO 
                           onLayer:self];
        [cyclesheet addChild:right];
        
        CLButton *left = [CLButton 
                          buttonForBike:blueBike 
                          asPlayerNo:playerNo 
                          isLeft:YES 
                          onLayer:self];
        [cyclesheet addChild:left];
    }
}

#pragma mark Collision Detection
-(void) checkForCollisions {
    for (CCSprite *aWall in bikeWalls) {
        // Compare wall to blue bike
        if (CGRectIntersectsRect([aWall boundingBox],
                                 [blueBike boundingBox]) 
            && aWall != blueBike.currentWall 
            && aWall != blueBike.priorWall) {
                  [self crashForBike:blueBike];
            break;
        }  
        //Compare wall to red bike
        if (CGRectIntersectsRect([aWall boundingBox], 
                                 [redBike boundingBox]) 
            && aWall != redBike.currentWall 
            && aWall != redBike.priorWall) {
                  [self crashForBike:redBike];
            break;
        }
        
    }
}

-(void) crashForBike:(CLBike*)thisBike {
    [self unscheduleUpdate];

    // The bike crash sequence
    [thisBike crash];
    
    // Prevent all touches for now
    isTouchBlocked = YES;
    
    // Identify game over
    isGameOver = YES;

    // Game over sequence
    [self displayGameOver];
}

-(void) displayGameOver {
    NSString *whoWon;
    
    if (redBike.isCrashed) {
        whoWon = @"Blue Player Wins!";
    } else {
        whoWon = @"Red Player Wins!";
    }

    CCLabelTTF *winner = [CCLabelTTF 
                          labelWithString:whoWon
                          fontName:@"Verdana" 
                          fontSize:30];
    [winner setPosition:ccp(size.width/2, size.height/2)];
    [winner setColor:ccWHITE];
    [self addChild:winner];
    
    // Animate the winner label
    CCScaleTo *scaleUp = [CCScaleTo
                          actionWithDuration:1.0
                          scale:2.0];
    CCScaleTo *scaleDown = [CCScaleTo 
                            actionWithDuration:1.0
                            scale:1.0];
    
    CCRepeatForever *repeat = [CCRepeatForever 
                               actionWithAction:
                               [CCSequence actions:
                                scaleUp,
                                scaleDown, nil]];
    [winner runAction:repeat];
    
    // Allow a pause before we 
    CCDelayTime *delay = [CCDelayTime 
                          actionWithDuration:3.0];
    CCCallBlock *allowExit = [CCCallBlock 
                              actionWithBlock:
                              ^{
                                  isTouchBlocked = NO;
                              }];
    
    [self runAction:[CCSequence actions:delay,
                     allowExit, nil]];
    
}

#pragma mark Create Walls
-(CCSprite*) createWallFromBike:(CLBike*)thisBike {
    
    CCSprite *aWall = [CCSprite 
                       spriteWithSpriteFrameName:IMG_SPECK];
    [aWall setColor:thisBike.wallColor];
    [aWall setAnchorPoint:[thisBike wallAnchorPoint]];
    [aWall setPosition:thisBike.position];
    
    [cyclesheet addChild:aWall];
    
    [bikeWalls addObject:aWall];
    
    return aWall;
}

-(void) createWallFrom:(CGPoint)orig to:(CGPoint)dest {
    CCSprite *aWall = [CCSprite 
                       spriteWithSpriteFrameName:IMG_SPECK];
    [aWall setColor:ccYELLOW];
    [aWall setPosition:orig];
    [aWall setAnchorPoint:ccp(0,0)];
    [aWall setScaleX:ABS(orig.x - dest.x) + 3];
    [aWall setScaleY:ABS(orig.y - dest.y) + 3];
    
    [cyclesheet addChild:aWall];
    
    [bikeWalls addObject:aWall]; 
}

-(void) createOuterWalls {
    // Bottom
    [self createWallFrom:ccp(59,62) to:ccp(709,62)];
    // Top
    [self createWallFrom:ccp(59,962) to:ccp(709,962)];
    // Left
    [self createWallFrom:ccp(59,62) to:ccp(59,962)];
    // Right
    [self createWallFrom:ccp(709,62) to:ccp(709,962)];
}

#pragma mark Touch Handler
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    // If game over splash is finished, next touch
    // returns to the menu
    if (isGameOver && isTouchBlocked == NO) {
        [self returnToMainMenu];
        return YES;
    } else {
        return NO;
    }
}

-(void) returnToMainMenu {
    // If there is a GameKit Session, invalidate it
    if(gkSession != nil) {
        [self invalidateSession:gkSession];
        gkSession = nil;
    }
    
    [[CCDirector sharedDirector] replaceScene:[CLMenuScene node]];
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

    [bikeWalls release];

    [super dealloc];
}


#pragma mark GameKit Integration
-(void) findPeer:(id)sender {
    //Initialize and show the picker
    gkPicker = [[GKPeerPickerController alloc] init];
    gkPicker.delegate = self;
    gkPicker.connectionTypesMask = 
                GKPeerPickerConnectionTypeNearby;
    [gkPicker show];
    
    playerNumber = 1;
}

-(GKSession*) peerPickerController:(GKPeerPickerController*)picker 
          sessionForConnectionType:(GKPeerPickerConnectionType)type {
             gkSession = [[GKSession alloc] 
             initWithSessionID:@"Ch6_Cycles"
             displayName:nil 
             sessionMode:GKSessionModePeer];
             gkSession.delegate = self;
             return gkSession;
}

-(void) peerPickerController:(GKPeerPickerController*)picker
              didConnectPeer:(NSString*)peerID 
                   toSession:(GKSession*)currSession {
    // Dismiss the peerPicker
    [gkSession setDataReceiveHandler:self
                         withContext:NULL];
    [gkPicker dismiss];
    gkPicker.delegate = nil;
    [gkPicker autorelease];
    
    //Set the other player's ID
    gamePeerId = peerID;
}

-(void) peerPickerControllerDidCancel:(GKPeerPickerController*)picker
{
    [gkPicker dismiss];
    gkPicker.delegate = nil;

    // Return to the main menu
    [self returnToMainMenu];
}

#pragma mark GKSessionDelegate
-(void) session:(GKSession*)session peer:(NSString*)peerID 
          didChangeState:(GKPeerConnectionState)state {
    // If we refused the connection we exit
    if (currentState == GKPeerStateConnecting &&
        state != GKPeerStateConnected) {
        // Reset the player number
        playerNumber = 1;
    } else if(state == GKPeerStateConnected){
		//We have now connected to a peer
        if (playerNumber == 2) {
            // We are the server, blue player
            [self generateRedAsPlayerNo:2 isRemote:YES];
            [self generateBlueAsPlayerNo:1 isRemote:NO];
        } else {
            // We are the client, red player
            [self generateRedAsPlayerNo:1 isRemote:NO];
            [self generateBlueAsPlayerNo:2 isRemote:YES];
        }

        // Start the game
        [self scheduleUpdate];    
	} else if(state == GKPeerStateDisconnected) {
		// We were disconnected
        [self unscheduleUpdate];

		// User alert
		NSString *msg = [NSString stringWithFormat:
                         @"Lost device %@.", 
                    [session displayNameForPeer:peerID]];
		UIAlertView *alert = [[UIAlertView alloc] 
                        initWithTitle:@"Lost Connection" 
                        message:msg delegate:self 
                        cancelButtonTitle:@"Game Ended" 
                        otherButtonTitles:nil];
		[alert show];
		[alert release];
        [self returnToMainMenu];
    }
    // Keep the current state
    currentState = state;
}

-(void) session:(GKSession*)session
didReceiveConnectionRequestFromPeer:(NSString*)peerI {
    //We are player 2 (blue)
    playerNumber = 2;
}

-(void) session:(GKSession*)session 
     connectionWithPeerFailed:(NSString*)peerID 
                    withError:(NSError*)error {
    // Connection Failed
    [gkPicker dismiss];
    gkPicker.delegate = nil;
    [gkPicker autorelease];

    [self returnToMainMenu];
}

-(void) session:(GKSession*)session 
                didFailWithError:(NSError*)error {
    // Connection Failed
    [gkPicker dismiss];
    gkPicker.delegate = nil;
    [gkPicker autorelease];
    
    [self returnToMainMenu];
}

-(void) invalidateSession:(GKSession*)session {
    if(session != nil) {
        [session disconnectFromAllPeers];
        session.available = NO;
        [session setDataReceiveHandler: nil 
                           withContext: NULL];
        session.delegate = nil;
        [session autorelease];
        session = nil;
    }
}

-(void) receiveData:(NSData*)data fromPeer:(NSString*)peer
          inSession:(GKSession*)session context:(void*)context {

    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver 
                    alloc] initForReadingWithData:data];

    Direction dir = [unarchiver 
                     decodeIntForKey:@"direction"];
    NSInteger dist = [unarchiver 
                      decodeFloatForKey:@"distance"];

    // Determine which bike to use, hold in whichBike 
    CLBike *whichBike = ((playerNumber == 1)? blueBike:
                         redBike);
    
    // Process the data
    if (dir == kNoChange) {
        // This was a move forward packet
        [whichBike moveForDistance:dist];
    } else if (dir == kLeft) {
        // This is a turn left packet
        [whichBike turnLeft];
    } else if (dir == kRight) {
        // This is a turn right packet
        [whichBike turnRight];
    }
}

-(void) sendDataWithDirection:(Direction)dir 
                   orDistance:(float)dist {

    //Pack data
    NSMutableData *dataToSend = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                initForWritingWithMutableData:dataToSend];

    [archiver encodeInt:dir forKey:@"direction"];
    [archiver encodeFloat:dist forKey:@"distance"];
    
    [archiver finishEncoding];
    
    // Send the data, reliably
        [gkSession sendData:dataToSend toPeers:
         [NSArray arrayWithObject:gamePeerId] 
               withDataMode:GKSendDataReliable
                      error:nil];

    [archiver release];
    [dataToSend release];
}

@end