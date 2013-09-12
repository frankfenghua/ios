//
//  OPPlayfieldLayer.mm
//  ch7-pool
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "OPPlayfieldLayer.h"
#import "OPPlayfieldScene.h"
#import "OPMenuScene.h"
#import "OPControlOneTouch.h"
#import "OPControlTwoTouch.h"
#import "OPRulesBase.h"

@implementation OPPlayfieldLayer

@synthesize isTouchBlocked;
@synthesize isGameOver;
@synthesize isHitReady;
@synthesize isBallInHand;

@synthesize table;
@synthesize poolcue;

@synthesize isUserDismissMsg;

+(id) gameWithControl:(NSString*)controls andRules:(NSString*)gameRules {
    return [[[self alloc] initWithControl:controls andRules:gameRules]autorelease];
}


-(id) initWithControl:(NSString*)controls andRules:(NSString*)gameRules {
    if(self = [super init]) {

        size = [[CCDirector sharedDirector] winSize];
        
        // Load the spritesheet
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"poolsheet.plist"];
        poolsheet = [CCSpriteBatchNode batchNodeWithFile:@"poolsheet.png"];
        
        // Add the batch node to the layer
        [self addChild:poolsheet z:1];
        
        
        table = [CCSprite spriteWithSpriteFrameName:@"table.png"];
        [table setPosition:ccp(size.width/2, size.height/2)];
        [poolsheet addChild:table];
        
        isGameOver = NO;
        isTouchBlocked = NO;
        isHitReady = NO;
        firstHit = kBallNone;
        
        ballsSunk = [[NSMutableArray alloc] init];
        p1BallsSunk = [[NSMutableArray alloc] init];
        p2BallsSunk = [[NSMutableArray alloc] init];
        
        // Start up the interface control structure
        if ([controls isEqualToString:@"One Touch"]) {
            // Add the controls
            contr = [[OPControlOneTouch alloc] init];
        } else if ([controls isEqualToString:@"Two Touch"])  {
            // Add the controls
            contr = [[OPControlTwoTouch alloc] init];
        } else {
            [self displayMessage:@"Failed To Find Controls" userDismiss:YES];
        }
        contr.mp = self;
        [self addChild:contr z:20];
        
        // Load the rules
        rules = [[OPRulesBase alloc] initWithRulesForGame:gameRules];
 
        // Set up the Box2D world
        [self initWorld];
        
        // Build the table features
        [self createRails];
        [self createPockets];
        
        [self createPoolCue];
        [self createPlayerScores];
        
        // Cue ball setup
        [self displayMessage:@"Place the cue ball" userDismiss:NO];
        isBallInHand = YES;

        // Build the variable elements
        [self createRackWithLayout:rules.rackStyle];
        
        // Update goal displays
        [self updatePlayerGoals];
        
        // Schedule the update method
        [self scheduleUpdate];
         
        // Enable this for debugging only
        //[self enableDebugDraw];

    }
    return self;
}

-(void) onEnterTransitionDidFinish {
    [super onEnterTransitionDidFinish];
}

-(void) makeTheShot {
    // Reset the "first hit" var
    firstHit = kBallNone;
    
    // The controller tells us where to aim
    CGPoint aimPoint = [contr aimAtPoint];

    // Set up the pool cue animation
    CCMoveTo *move = [CCMoveTo actionWithDuration:0.05
                                         position:aimPoint];
    CCCallBlock *hitIt = [CCCallBlock actionWithBlock:^{
        // Get ready to hit the ball
        b2Vec2 impulse = b2Vec2(contr.plannedHit.x,
                                contr.plannedHit.y);
        b2Vec2 aim = b2Vec2(aimPoint.x / PTM_RATIO,
                            aimPoint.y / PTM_RATIO);
        // Hit it
        cueBallBody->ApplyLinearImpulse(impulse, aim);
    }];
    CCDelayTime *wait = [CCDelayTime actionWithDuration:0.1];
    CCFadeOut *fadeCue = [CCFadeOut actionWithDuration:0.4];
    
    CCCallBlock *checkTbl = [CCCallBlock actionWithBlock:^{
        pendingTable = YES;
    }];
    
    CCCallFunc *hideCue = [CCCallFunc actionWithTarget:contr
                            selector:@selector(hideCue)];
    
    [poolcue runAction:[CCSequence actions:move, hitIt,
                        wait, fadeCue, hideCue, checkTbl,  nil]];
}


-(void) returnToMainMenu {
    [[CCDirector sharedDirector] replaceScene:[OPMenuScene node]];
}

#pragma mark Enter, Exit, and Dealloc
-(void)onEnter
{
    [super onEnter];
}

-(void)onExit
{
    [self unscheduleAllSelectors];
    
    [ballsSunk release];
    [p1BallsSunk release];
    [p2BallsSunk release];
    
    delete contactListener;
    contactListener = NULL;
    
    delete world;
    world = NULL;
    
    contr.mp = nil;
    [contr release];
    
    [rules release];

    [super onExit];
}

-(void) dealloc {

    [super dealloc];
}

#pragma mark Update
-(void) update: (ccTime) dt
{
	int32 velocityIterations = 30;
	int32 positionIterations = 30;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);	

    // Evaluate all contacts
    std::vector<b2Body *>toDestroy;
	std::vector<OPContact>::iterator pos;
	for (pos = contactListener->_contacts.begin();
		 pos != contactListener->_contacts.end(); pos++) {
		OPContact contact = *pos;
		
        // Get the bodies involved in this contact
		b2Body *bodyA = contact.fixtureA->GetBody();
		b2Body *bodyB = contact.fixtureB->GetBody();
        
        // Get the sprites attached to these bodies
        CCSprite *spriteA = (CCSprite*)bodyA->GetUserData();
        CCSprite *spriteB = (CCSprite*)bodyB->GetUserData();
        
        // Look for balls touching the pocket sensor
        if ([spriteA isMemberOfClass:[OPBall class]] &&
            spriteB.tag == kPocket) {
            if (std::find(toDestroy.begin(),
                          toDestroy.end(),
                          bodyA) == toDestroy.end()) {
                toDestroy.push_back(bodyA);
            }
        }
        // Check the same collision with opposite A/B
        else if (spriteA.tag == kPocket && [spriteB
                    isMemberOfClass:[OPBall class]]) {
            if (std::find(toDestroy.begin(),
                          toDestroy.end(),
                          bodyB) == toDestroy.end()) {
                toDestroy.push_back(bodyB);
            }
        }
        
        if ([spriteA isMemberOfClass:[OPBall class]] &&
            [spriteB isMemberOfClass:[OPBall class]]) {
            // Two balls collided
            // Let's store the FIRST collision
            if ((spriteA.tag == kBallCue ||
                 spriteB.tag == kBallCue) &&
                firstHit == kBallNone) {
                if (spriteA.tag == kBallCue) {
                    firstHit = (BallID)spriteB.tag;
                } else {
                    firstHit = (BallID)spriteA.tag;
                }
            }
        }
	}
    
    // Destroy any bodies & sprites we need to get rid of
    std::vector<b2Body *>::iterator pos2;
    for(pos2 = toDestroy.begin();
        pos2 != toDestroy.end(); ++pos2) {
        b2Body *body = *pos2;
        if (body->GetUserData() != NULL) {
            OPBall *sprite = (OPBall *) body->GetUserData();
            [self sinkBall:sprite];
        }
        
        world->DestroyBody(body);
    }
    
    if ([self isTableMoving]) {
        self.isTouchBlocked = YES;
    } else {
        self.isTouchBlocked = NO;

        // Table is done.  Let's resolve the action.
        if (pendingTable) {
            [self checkTable];
            
            pendingTable = NO;
        }
    }
}

-(void) sinkBall:(OPBall*)thisBall {

    // Keep the ball in the temp array
    [ballsSunk addObject:thisBall];
    
    // Destroy The Sprite
    [thisBall removeFromParentAndCleanup:YES];
}

-(void) checkTable {
    
    NSInteger currPlayer = [rules currentPlayer];

    BOOL isValidFirst = NO;
    BOOL isValidSink = NO;
    BOOL isLastBall = NO;
    BOOL isTableScratch = NO;
    BOOL isScratch = NO;
    BOOL replaceBalls = NO;
    BOOL isPlayerChange = NO;
    BOOL isValidLastBall = NO;
    BOOL playerLoses = NO;
    
    isValidFirst = [rules isLegalFirstHit:firstHit];
    isValidSink = [rules didSinkValidBall:ballsSunk];
    isTableScratch = [rules isTableScratch];
    isLastBall = [rules didSinkLastBall:ballsSunk];
    isScratch = [rules didSinkCueBall:ballsSunk];
    isValidLastBall = [rules isValidLastBall:ballsSunk withBallsOnTable:[self ballSpritesOnTable]];
    
    if (isLastBall) {
        if (isValidLastBall) {
            if (isScratch) {
                // Player loses
                playerLoses = YES;
            } else {
                // Player wins
                isGameOver = YES;
                [self gameOverWithWinner:[rules currentPlayer]];
                return;
            }
        } else {
            // player loses
            playerLoses = YES;
        }
    }
    
    if (playerLoses) {
        isGameOver = YES;
        [self displayMessage:@"Fail!" userDismiss:NO];
        [self gameOverWithLoser:[rules currentPlayer]];
        return;
    }
    
    
    if (isScratch) {
        [self displayMessage:@"Scratched" userDismiss:NO];
        [self displayMessage:@"Place the cue ball" userDismiss:NO];
        replaceBalls = YES;
        isBallInHand = YES;
        isPlayerChange = YES;
    }
    else if (isTableScratch) {
        replaceBalls = YES;
        [self displayMessage:@"table scratch" userDismiss:NO];
        isPlayerChange = YES;
    }
    else if (isValidFirst == NO) {
        replaceBalls = YES;
        [self displayMessage:@"wrong first ball hit" userDismiss:NO];
        isPlayerChange = YES;
    }
    else if (isValidSink) {
        if (currPlayer == 1) {
            [p1BallsSunk addObjectsFromArray:ballsSunk];
            
            // If there is nothing set, choose
            if ([rules player1Goal] == kStripesVsSolids) {
                OPBall *aBall = [p1BallsSunk objectAtIndex:0];
                if (aBall.tag < 8) {
                    [rules setPlayer1Goal:kSolids];
                    [rules setPlayer2Goal:kStripes];
                } else {
                    [rules setPlayer1Goal:kStripes];
                    [rules setPlayer2Goal:kSolids];
                }
            }
        }
        else {
            [p2BallsSunk addObjectsFromArray:ballsSunk];
            
            // If there is nothing set, choose
            if ([rules player2Goal] == kStripesVsSolids) {
                OPBall *aBall = [p2BallsSunk objectAtIndex:0];
                if (aBall.tag < 8) {
                    [rules setPlayer2Goal:kSolids];
                    [rules setPlayer1Goal:kStripes];
                } else {
                    [rules setPlayer2Goal:kStripes];
                    [rules setPlayer1Goal:kSolids];
                }
            }
        }
    } else {
        // Nothing dropped, but the hit was OK.
        // Change players
        isPlayerChange = YES;
    }
    
    // If we need to put balls back on the table
    if (replaceBalls) {
        [self putBallsBackOnTable:ballsSunk];
    }
    
    if (isPlayerChange) {
        [self playerChange];
    }
    
    // Clear the array for the next turn
    [ballsSunk removeAllObjects];
    
    // Update goal displays as needed
    [self updatePlayerGoals];

}

-(CGPoint) getCueBallPos {
    // Get the cue ball's position
    b2Vec2 cuePosb2 = cueBallBody->GetPosition();
    return ccp(cuePosb2.x * PTM_RATIO,
               cuePosb2.y * PTM_RATIO);
}

-(void)putBallsBackOnTable:(NSMutableArray*)ballArray {
    
    // We put the balls we need back on the table,
    // following racking positions, if the rules specify
    
    if ([rules replaceBalls]) {
        NSMutableArray *deleteArray = [[NSMutableArray alloc] init];
        
        // First we make sure the cue is NOT in the array
        for (OPBall *aBall in ballArray) {
            // If it is, we add it to the delete array
            if (aBall.tag == kBallCue) {
                [deleteArray addObject:aBall];
            }
        }
        
        // Delete any flagged balls from the array
        [ballArray removeObjectsInArray:deleteArray];
        [deleteArray release];
        
        CGPoint footSpot = ccp(160,335);
        
        CGPoint r1b1 = ccp(153,348);
        CGPoint r1b2 = ccp(167,348);
        
        CGPoint r2b1 = ccp(146,361);
        CGPoint r2b2 = ccp(160,361);
        CGPoint r2b3 = ccp(174,361);
        
        for (int i = 0; i < [ballArray count]; i++) {
            OPBall *thisBall = [ballArray objectAtIndex:i];
            BallID newBall = (BallID)thisBall.tag;
            
            switch (i) {
                case 0:
                    // foot spot
                    [self createBall:newBall AtPos:footSpot];
                    break;
                case 1:
                    // r1b1
                    [self createBall:newBall AtPos:r1b1];
                    break;
                case 2:
                    // r1b2
                    [self createBall:newBall AtPos:r1b2];
                    break;
                case 3:
                    // r2b1
                    [self createBall:newBall AtPos:r2b1];
                    break;
                case 4:
                    // r2b2
                    [self createBall:newBall AtPos:r2b2];
                    break;
                case 5:
                    // r2b3
                    [self createBall:newBall AtPos:r2b3];
                    break;
                default:
                    break;
            }
        }
    }
}

#pragma mark Player interactions
-(void) playerChange {
    if ([rules currentPlayer] == 1) {
        [self displayMessage:@"Player 2's turn" userDismiss:NO];
        [rules setCurrentPlayer:2];
        [markPlayer setPosition:ccp(300,450)];
    } else {
        [self displayMessage:@"Player 1's turn" userDismiss:NO];
        [rules setCurrentPlayer:1];
        [markPlayer setPosition:ccp(20,450)];
    }
}

-(void) createPlayerScores {
    CCLabelTTF *player1 = [CCLabelTTF
                           labelWithString:@"P1"
                           fontName:@"Verdana"
                           fontSize:14];
    [player1 setPosition:ccp(20,460)];
    [self addChild:player1];
    
    CCLabelTTF *player2 = [CCLabelTTF
                           labelWithString:@"P2"
                           fontName:@"Verdana"
                           fontSize:14];
    [player2 setPosition:ccp(300,460)];
    [self addChild:player2];
    
    player1TargetLbl = [CCLabelTTF
                        labelWithString:@" "
                        fontName:@"Verdana" fontSize:8];
    [player1TargetLbl setPosition:ccp(20,440)];
    [self addChild:player1TargetLbl z:2];
    
    player2TargetLbl = [CCLabelTTF
                        labelWithString:@" "
                        fontName:@"Verdana" fontSize:8];
    [player2TargetLbl setPosition:ccp(300,440)];
    [self addChild:player2TargetLbl z:2];
    
    markPlayer = [CCSprite spriteWithSpriteFrameName:
                  @"whitespeck.png"];
    [markPlayer setColor:ccGREEN];
    [markPlayer setPosition:ccp(20,450)];
    [markPlayer setScaleX:10 * CC_CONTENT_SCALE_FACTOR()];
    [self addChild:markPlayer z:2];
    
    // Update the display
    if ([rules orderedBalls]) {
        CCLabelTTF *nextBallLbl = [CCLabelTTF
                            labelWithString:@"Next Ball"
                            fontName:@"Verdana"
                            fontSize:12];
        [nextBallLbl setPosition:ccp(122,470)];
        [self addChild:nextBallLbl z:100];
    }
}

-(void) updatePlayerGoals {
    // Update the stripes/solids display for the players
    if ([rules player1Goal] == kStripes) {
        [player1TargetLbl setString:@"Stripes"];
        [player2TargetLbl setString:@"Solids"];
    } else if ([rules player1Goal] == kSolids) {
        [player1TargetLbl setString:@"Solids"];
        [player2TargetLbl setString:@"Stripes"];
    }
    
    // Update the display
    if ([rules orderedBalls]) {
        // Update the ordered ball goals, if applicable
        [rules findNextOrderedBall:
                    [self ballSpritesOnTable]];
        
        if (nextGoal != nil) {
            [nextGoal removeFromParentAndCleanup:YES];
        }
        
        // Create the filename
        NSString *ballImg = [NSString stringWithFormat:
                        @"ball_%i.png",
                        (BallID)[rules nextOrderedBall]];
        // Create sprite and add it to layer
        nextGoal = [CCSprite spriteWithSpriteFrameName:
                    ballImg];
        [nextGoal setPosition:ccp(160,470)];
        [self addChild:nextGoal];
        
    }
}

-(void) gameOverWithWinner:(NSInteger)winningPlayer {
    NSString *msg = [NSString stringWithFormat:@"Player %i Wins!", winningPlayer];

    [self displayMessage:msg userDismiss:YES];
}

-(void) gameOverWithLoser:(NSInteger)losingPlayer {
    if ([rules currentPlayer] == 1) {
        [self gameOverWithWinner:2];
    } else {
        [self gameOverWithWinner:1];
    }
}

#pragma mark Messaging
-(void) displayMessage:(NSString*)msg userDismiss:(BOOL)userDismiss {
    // If there is a current message, wait for it to
    // go away
    if (isDisplayingMsg) {
        CCDelayTime *del = [CCDelayTime
                            actionWithDuration:0.1];
        CCCallBlock *retry = [CCCallBlock
                              actionWithBlock:^{
          [self displayMessage:msg
                   userDismiss:userDismiss];
        }];
        [self runAction:[CCSequence actions:del,
                         retry, nil]];
        return;
    }
    
    isDisplayingMsg = YES;
    isUserDismissMsg = userDismiss;
    
    // Create the message label & display it
    message = [CCLabelTTF labelWithString:msg
                                 fontName:@"Verdana"
                                 fontSize:20];
    [message setPosition:ccp(size.width/2,
                             size.height/2)];
    [self addChild:message z:20];
    
    // If userDismiss is NO, set a 2 second destruct
    if (userDismiss == NO) {
        CCDelayTime *wait = [CCDelayTime
                             actionWithDuration:2.0f];
        CCCallFunc *dismiss = [CCCallFunc
                    actionWithTarget:self
                    selector:@selector(dismissMessage)];
        
        [self runAction:[CCSequence actions:wait,
                         dismiss, nil]];
    }
}

-(void) dismissMessage {
    isDisplayingMsg = NO;
    [message removeFromParentAndCleanup:YES];
}

#pragma mark Establish Box2D World
-(void) initWorld
{
	b2Vec2 gravity;
	gravity.Set(0.0f, 0.0f);
	world = new b2World(gravity);
	
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(true);
	
	world->SetContinuousPhysics(true);
    
    // Create contact listener
    contactListener = new OPContactListener();
    world->SetContactListener(contactListener);
}

#pragma mark Pocket builders
-(void) createPocketAtPos:(CGPoint)pos {
    // The pockets are just sensors
    // We use a sprite only to give a "target"
    // for balls being sunk

    // Create sprite and add it to layer
    CCSprite *pocket = [CCSprite spriteWithSpriteFrameName:@"whitespeck.png"];
    pocket.position = pos;
    pocket.tag = kPocket;
    [pocket setColor:ccBLACK];
    [self addChild:pocket z:0];

    // Create a pocket body
    b2BodyDef pocketBodyDef;
    pocketBodyDef.type = b2_dynamicBody;
    pocketBodyDef.position.Set(pos.x/PTM_RATIO, 
                             pos.y/PTM_RATIO);
    pocketBodyDef.userData = pocket;
    b2Body *pocketBody = world->CreateBody(&pocketBodyDef);
    
    //Create a circle shape
    b2CircleShape circle;
    circle.m_radius = 7.0/PTM_RATIO;
    
    //Create fixture definition and add to body
    b2FixtureDef pocketFixtureDef;
    pocketFixtureDef.shape = &circle;
    pocketFixtureDef.isSensor = YES;

    pocketBody->CreateFixture(&pocketFixtureDef);
}

-(void) createPockets {
    // Left top pocket
    [self createPocketAtPos:ccp(57,437)];

    // Left middle pocket
    [self createPocketAtPos:ccp(52,240)];
    
    // Left bottom pocket
    [self createPocketAtPos:ccp(57,43)];

    // Right top pocket
    [self createPocketAtPos:ccp(265,437)];
    
    // Right middle pocket
    [self createPocketAtPos:ccp(272,240)];
    
    // Right bottom pocket
    [self createPocketAtPos:ccp(265,43)];
}

#pragma mark Rails builders
-(void) createRailWithImage:(NSString*)img atPos:(CGPoint)pos withVerts:(b2Vec2*)verts {
    // Create the rail
    PhysicsSprite *rail = [PhysicsSprite spriteWithSpriteFrameName:img];
    [rail setPosition:pos];
    [poolsheet addChild: rail];
    
    // Create rail body
    b2BodyDef railBodyDef;
    railBodyDef.type = b2_staticBody;
    railBodyDef.position.Set(pos.x/PTM_RATIO, 
                             pos.y/PTM_RATIO);
    railBodyDef.userData = rail;
    b2Body *railBody = world->CreateBody(&railBodyDef);
    
    // Store the body in the sprite
    [rail setPhysicsBody:railBody];
    
    // Build the fixure
    b2PolygonShape railShape;
    int num = 4;

    railShape.Set(verts, num);
    
    // Create the shape definition and add it to the body
    b2FixtureDef railShapeDef;
    railShapeDef.shape = &railShape;
    railShapeDef.density = 50.0f;
    railShapeDef.friction = 0.3f;
    railShapeDef.restitution = 0.5f;
    railBody->CreateFixture(&railShapeDef);  
}

-(void) createRails {

    // Top left rail
    CGPoint railPos1 = ccp(58,338);
    
    b2Vec2 vert1[] = {
        b2Vec2(5.5f / PTM_RATIO, -84.0f / PTM_RATIO),
        b2Vec2(4.5f / PTM_RATIO, 80.0f / PTM_RATIO),
        b2Vec2(-5.5f / PTM_RATIO, 87.0f / PTM_RATIO),
        b2Vec2(-5.5f / PTM_RATIO, -87.0f / PTM_RATIO)
    };
    
    [self createRailWithImage:@"rail1.png" atPos:railPos1 withVerts:vert1];

    // Bottom left rail
    CGPoint railPos2 = ccp(58,142);
    
    b2Vec2 vert2[] = {
        b2Vec2(5.5f / PTM_RATIO, 84.5f / PTM_RATIO),
        b2Vec2(-5.5f / PTM_RATIO, 86.5f / PTM_RATIO),
        b2Vec2(-5.5f / PTM_RATIO, -86.5f / PTM_RATIO),
        b2Vec2(5.5f / PTM_RATIO, -78.5f / PTM_RATIO)
    };    
    
    [self createRailWithImage:@"rail2.png" atPos:railPos2 withVerts:vert2];
    
    // Bottom rail
    CGPoint railPos3 = ccp(160,44);
    
    b2Vec2 vert3[] = {
        b2Vec2(-88.5f / PTM_RATIO, -5.5f / PTM_RATIO),
        b2Vec2(88.5f / PTM_RATIO, -5.5f / PTM_RATIO),
        b2Vec2(81.5f / PTM_RATIO, 5.5f / PTM_RATIO),
        b2Vec2(-81.5f / PTM_RATIO, 5.5f / PTM_RATIO)
    };    
    
    [self createRailWithImage:@"rail3.png" atPos:railPos3 withVerts:vert3];
    
    // Bottom right rail
    CGPoint railPos4 = ccp(262,142);
    
    b2Vec2 vert4[] = {
        b2Vec2(5.5f / PTM_RATIO, -86.0f / PTM_RATIO),
        b2Vec2(5.5f / PTM_RATIO, 86.0f / PTM_RATIO),
        b2Vec2(-5.5f / PTM_RATIO, 85.0f / PTM_RATIO),
        b2Vec2(-5.5f / PTM_RATIO, -78.0f / PTM_RATIO)
    };    
    
    [self createRailWithImage:@"rail4.png" atPos:railPos4 withVerts:vert4];
    
    // Top right rail
    CGPoint railPos5 = ccp(262,338);
    
    b2Vec2 vert5[] = {
        b2Vec2(5.5f / PTM_RATIO, 86.5f / PTM_RATIO),
        b2Vec2(-5.5f / PTM_RATIO, 78.5f / PTM_RATIO),
        b2Vec2(-5.5f / PTM_RATIO, -85.5f / PTM_RATIO),
        b2Vec2(5.5f / PTM_RATIO, -86.5f / PTM_RATIO)
    };    
    
    [self createRailWithImage:@"rail5.png" atPos:railPos5 withVerts:vert5];
    
    // Top rail
    CGPoint railPos6 = ccp(160,436);
    
    b2Vec2 vert6[] = {
        b2Vec2(89.0f / PTM_RATIO, 6.0f / PTM_RATIO),
        b2Vec2(-89.0f / PTM_RATIO, 6.0f / PTM_RATIO),
        b2Vec2(-82.0f / PTM_RATIO, -5.0f / PTM_RATIO),
        b2Vec2(81.0f / PTM_RATIO, -5.0f / PTM_RATIO)
    };    
    
    [self createRailWithImage:@"rail6.png" atPos:railPos6 withVerts:vert6];
}

-(void) createPoolCue {
    poolcue = [CCSprite spriteWithSpriteFrameName:@"cue_stick.png"];
    [poolcue setAnchorPoint:ccp(0.5,1)];
    [poolcue setVisible:NO];
    [poolsheet addChild:poolcue z:50];
}

#pragma mark Ball builders
-(void) createBall:(BallID)ballID AtPos:(CGPoint)startPos {
    // Create the filename
    NSString *ballImg = [NSString stringWithFormat:@"ball_%i.png",ballID];
    
    // Create sprite and add it to layer
    OPBall *ball = [OPBall spriteWithSpriteFrameName:ballImg];
    ball.position = startPos;
    ball.tag = ballID;
    [self addChild:ball z:10];
    
    // Create ball body
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;
    ballBodyDef.position.Set(startPos.x/PTM_RATIO,
                             startPos.y/PTM_RATIO);
    ballBodyDef.userData = ball;
    b2Body *ballBody = world->CreateBody(&ballBodyDef);
    
    // Store the body in the sprite
    [ball setPhysicsBody:ballBody];
    
    //Create a circle shape
    b2CircleShape circle;
    circle.m_radius = 7.5/PTM_RATIO;  // 7.5 point radius
    
    //Create fixture definition and add to body
    b2FixtureDef ballFixtureDef;
    ballFixtureDef.shape = &circle;
    ballFixtureDef.density = 1.0f;
    ballFixtureDef.friction = 0.5f;
    ballFixtureDef.restitution = 0.9f;
    
    ballBody->CreateFixture(&ballFixtureDef);
    ballBody->SetFixedRotation(false);
    ballBody->SetLinearDamping(0.7f);
    ballBody->SetAngularDamping(0.5f);
    ballBody->SetBullet(TRUE);
    
    if (ballID == kBallCue) {
        cueBallBody = ballBody;
    }
}

-(void) createRackWithLayout:(RackLayoutType)rack {
    // Define the standard ball positions
    CGPoint footSpot = ccp(160,335);
    CGPoint r1b1 = ccp(153,348);
    CGPoint r1b2 = ccp(167,348);
    CGPoint r2b1 = ccp(146,361);
    CGPoint r2b2 = ccp(160,361);
    CGPoint r2b3 = ccp(174,361);
    CGPoint r3b1 = ccp(139,374);
    CGPoint r3b2 = ccp(153,374);
    CGPoint r3b3 = ccp(167,374);
    CGPoint r3b4 = ccp(181,374);
    CGPoint r4b1 = ccp(132,388);
    CGPoint r4b2 = ccp(146,388);
    CGPoint r4b3 = ccp(160,388);
    CGPoint r4b4 = ccp(174,388);
    CGPoint r4b5 = ccp(188,388);
    
    switch (rack) {
        case kRackTriangle:
            // Build a standard triangle rack
            [self createBall:kBallNine AtPos:footSpot];
            [self createBall:kBallSeven AtPos:r1b1];
            [self createBall:kBallTwelve AtPos:r1b2];
            [self createBall:kBallFifteen AtPos:r2b1];
            [self createBall:kBallEight AtPos:r2b2];
            [self createBall:kBallOne AtPos:r2b3];
            [self createBall:kBallSix AtPos:r3b1];
            [self createBall:kBallTen AtPos:r3b2];
            [self createBall:kBallThree AtPos:r3b3];
            [self createBall:kBallFourteen AtPos:r3b4];
            [self createBall:kBallEleven AtPos:r4b1];
            [self createBall:kBallTwo AtPos:r4b2];
            [self createBall:kBallThirteen AtPos:r4b3];
            [self createBall:kBallFour AtPos:r4b4];
            [self createBall:kBallFive AtPos:r4b5];
            break;
        case kRackDiamond:
            // Build a diamond rack
            [self createBall:kBallOne AtPos:footSpot];
            [self createBall:kBallFive AtPos:r1b1];
            [self createBall:kBallSeven AtPos:r1b2];
            [self createBall:kBallEight AtPos:r2b1];
            [self createBall:kBallNine AtPos:r2b2];
            [self createBall:kBallThree AtPos:r2b3];
            [self createBall:kBallTwo AtPos:r3b2];
            [self createBall:kBallSix AtPos:r3b3];
            [self createBall:kBallFour AtPos:r4b3];
            break;
        default:
            break;
    }
}

-(BOOL) isTableMoving {
    
    for(b2Body *b = world->GetBodyList(); b;b=b->GetNext()) {
        // See if the body is still noticeably moving
        b2Vec2 vel = b->GetLinearVelocity();

        if (vel.Length() > 0.005f) {
            return YES;
        }
    }
    return NO;
}

-(NSArray*) ballSpritesOnTable {
    // Returns an array of all ball sprites on the table
    NSMutableArray *currentBalls = [[[NSMutableArray alloc] initWithCapacity:16] autorelease];
    
    for(b2Body *b = world->GetBodyList(); b;b=b->GetNext()) {
        if (b->GetUserData() != nil) {
            OPBall *aBall = (OPBall*)b->GetUserData();
            if (aBall.tag < 100) {
                [currentBalls addObject:aBall];
            }
        }
    }
    return currentBalls;
}

@end