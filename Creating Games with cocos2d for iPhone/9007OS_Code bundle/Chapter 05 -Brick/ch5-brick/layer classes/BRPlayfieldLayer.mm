//
//  BRPlayfieldLayer.mm
//  ch5-brick
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "BRPlayfieldLayer.h"
#import "BRPlayfieldScene.h"
#import "BRMenuScene.h"

@implementation BRPlayfieldLayer

-(id) init {
    if (self == [super init]) {
        
        self.isTouchEnabled = YES;

        size = [[CCDirector sharedDirector] winSize];
        
        // Instantiate the game handler singleton
        gh = [BRGameHandler sharedManager];
        [gh setPlayfieldLayer:self];
        
        // Load the spritesheet
        [[CCSpriteFrameCache sharedSpriteFrameCache]
            addSpriteFramesWithFile:@"bricksheet.plist"];
        bricksheet = [CCSpriteBatchNode batchNodeWithFile:
            @"bricksheet.png" capacity:100];

        // Add the batch node to the layer
        [self addChild:bricksheet z:1];

        // Add the background
        CCSprite *bg = [CCSprite spriteWithSpriteFrameName:
                        @"brick_bg.png"];
        [bg setPosition:ccp(size.width/2,size.height/2)];
        [bricksheet addChild:bg z:-2];

        // Build the basic Box2D world
        [self setupWorld];
        
        // Define the boundaries of the playfield
        [self buildEdges];

        // Build the paddle
        [self buildPaddleAtStartingPosition:
                                ccp(size.width/2,75)];

        // Load the level patterns
        patternDefs = [NSDictionary dictionaryWithDictionary:
                [gh getDictionaryFromPlist:@"patterns"]];

        // Load the brick pattern
        NSInteger uniquePatterns = 4;
        NSInteger newPattern =( [gh currentLevel] -1)
                                    % uniquePatterns;
        [self buildBricksWithPattern:newPattern];

        // Various variable initializations
        isPaddleDeformed = NO;
        paddleTimer = 0;
        multiballCounter = 0;
        isBallInPlay = NO;
        shouldStartMultiball = NO;
        isGameOver = NO;
        
        // This will add a separate debug draw layer
        //[self enableDebugDraw];

    }
    return self;
}


-(void) onEnterTransitionDidFinish {
    [super onEnterTransitionDidFinish];

    // Add the HUD layer 
    [self createHUD];
    
    // We create ball first so the player knows where
    // it will be starting
    [self newBall];
    
    // Start the level splash sequence
    [self levelStartSplash];
    
}

-(void) dealloc {
    
    [super dealloc];
}

-(void) startGame {
    // Start updating the physics & rendering
    [self scheduleUpdate];   
}

#pragma mark Box2D World & Object Setup
-(void) setupWorld {
    // Define the gravity vector.
    b2Vec2 gravity;
    gravity.Set(0.0f, 0.0f);
    
    // Construct a world object
    world = new b2World(gravity);

	world->SetAllowSleeping(true);
    world->SetContinuousPhysics(true);

    // Create contact listener
    contactListener = new BRContactListener();
    world->SetContactListener(contactListener);
}

-(void) buildEdges {
    // Define the wall body
    b2BodyDef wallBodyDef;
    wallBodyDef.position.Set(0, 0);
    
    // Create a body for the walls
    wallBody = world->CreateBody(&wallBodyDef);
    
    // This defines where the bottom edge of the HUD is
    float maxY = 424;
    
    // Define the 4 corners of the playfield
    b2Vec2 bl(0.0f, 0.0f); // bottom left corner
    b2Vec2 br(size.width/PTM_RATIO,0); // bottom right
    b2Vec2 tl(0,maxY/PTM_RATIO); // top left corner
    b2Vec2 tr(size.width/PTM_RATIO,maxY/PTM_RATIO); // top right
    
    b2EdgeShape bottomEdge;
    b2EdgeShape leftEdge;
    b2EdgeShape rightEdge;
    b2EdgeShape topEdge;
    
    // Set the edges
    bottomEdge.Set(bl, br);
    leftEdge.Set(bl, tl);
    rightEdge.Set(br, tr);
    topEdge.Set(tl, tr);

    // Define the fixtures for the walls
    wallBody->CreateFixture(&topEdge,0);
    wallBody->CreateFixture(&leftEdge,0);
    wallBody->CreateFixture(&rightEdge,0);

    // Keep a reference to the bottom wall
    bottomGutter = wallBody->CreateFixture(&bottomEdge,0);
}

-(void) buildPaddleAtStartingPosition:(CGPoint)startPos {
    // Create the paddle
    paddle = [PhysicsSprite spriteWithSpriteFrameName:
                                        @"paddle.png"];
    paddle.position = startPos;
    paddle.tag = kPaddle;
    [bricksheet addChild: paddle];
    
    // Create paddle body
    b2BodyDef paddleBodyDef;
    paddleBodyDef.type = b2_dynamicBody;
    paddleBodyDef.position.Set(startPos.x/PTM_RATIO, 
                               startPos.y/PTM_RATIO);
    paddleBodyDef.userData = paddle;
    paddleBody = world->CreateBody(&paddleBodyDef);
    
    // Connect the body to the sprite
    [paddle setPhysicsBody:paddleBody];
    
    // Build normal size fixure
    [self buildPaddleFixtureNormal];
    
    // Restrict paddle along the x axis
    b2PrismaticJointDef jointDef;
    b2Vec2 worldAxis(1.0f, 0.0f);
    jointDef.collideConnected = true;
    jointDef.Initialize(paddleBody, wallBody,
            paddleBody->GetWorldCenter(), worldAxis);
    world->CreateJoint(&jointDef);
}

-(void) buildPaddleFixtureWithShape:(b2PolygonShape)shape
                 andSpriteFrameName:(NSString*)frameName {
    if (paddleFixture != nil) {
        paddleBody->DestroyFixture(paddleFixture);
    }
    
    // Create the paddle shape definition and add it to the body
    b2FixtureDef paddleShapeDef;
    paddleShapeDef.shape = &shape;
    paddleShapeDef.density = 50.0f;
    paddleShapeDef.friction = 0.0f;
    paddleShapeDef.restitution = 0.0f;
    paddleFixture = paddleBody->CreateFixture(&paddleShapeDef);
    
    // Swap the sprite image to the normal paddle
    [paddle setDisplayFrame:[[CCSpriteFrameCache
                              sharedSpriteFrameCache]
                             spriteFrameByName:frameName]];
}

-(void) buildPaddleFixtureNormal {
    // Define the paddle shape
    b2PolygonShape paddleShape;
    int num = 8;
    b2Vec2 verts[] = {
        b2Vec2(31.5f / PTM_RATIO, -7.5f / PTM_RATIO),
        b2Vec2(31.5f / PTM_RATIO, -0.5f / PTM_RATIO),
        b2Vec2(30.5f / PTM_RATIO, 0.5f / PTM_RATIO),
        b2Vec2(22.5f / PTM_RATIO, 6.5f / PTM_RATIO),
        b2Vec2(-24.5f / PTM_RATIO, 6.5f / PTM_RATIO),
        b2Vec2(-31.5f / PTM_RATIO, 1.5f / PTM_RATIO),
        b2Vec2(-32.5f / PTM_RATIO, 0.5f / PTM_RATIO),
        b2Vec2(-32.5f / PTM_RATIO, -7.5f / PTM_RATIO),
    };
    paddleShape.Set(verts, num);
    
    // Build the fixture
    [self buildPaddleFixtureWithShape:paddleShape
                   andSpriteFrameName:@"paddle.png"];
}

-(void) buildPaddleFixtureLong {
    // Define the paddle shape
    b2PolygonShape paddleShape;
    int num = 6;
    b2Vec2 verts[] = {
        b2Vec2(64.0f / PTM_RATIO, -7.5f / PTM_RATIO),
        b2Vec2(64.0f / PTM_RATIO, -0.5f / PTM_RATIO),
        b2Vec2(45.0f / PTM_RATIO, 6.5f / PTM_RATIO),
        b2Vec2(-48.0f / PTM_RATIO, 6.5f / PTM_RATIO),
        b2Vec2(-65.0f / PTM_RATIO, 0.5f / PTM_RATIO),
        b2Vec2(-65.0f / PTM_RATIO, -7.5f / PTM_RATIO)
    };
    paddleShape.Set(verts, num);
    
    // Build the fixture
    [self buildPaddleFixtureWithShape:paddleShape
                   andSpriteFrameName:@"paddle_wide.png"];
}

-(void) buildPaddleFixtureShort {
    // Define the paddle shape
    b2PolygonShape paddleShape;
    int num = 7;
    b2Vec2 verts[] = {
        b2Vec2(15.5f / PTM_RATIO, -7.5f / PTM_RATIO),
        b2Vec2(15.5f / PTM_RATIO, -0.5f / PTM_RATIO),
        b2Vec2(11.5f / PTM_RATIO, 5.5f / PTM_RATIO),
        b2Vec2(10.5f / PTM_RATIO, 6.5f / PTM_RATIO),
        b2Vec2(-12.5f / PTM_RATIO, 6.5f / PTM_RATIO),
        b2Vec2(-16.5f / PTM_RATIO, 0.5f / PTM_RATIO),
        b2Vec2(-16.5f / PTM_RATIO, -7.5f / PTM_RATIO)
    };
    paddleShape.Set(verts, num);
    
    // Build the fixture
    [self buildPaddleFixtureWithShape:paddleShape
                   andSpriteFrameName:@"paddle_short.png"];
}

-(void) buildBallAtStartingPosition:(CGPoint)startPos
                 withInitialImpulse:(b2Vec2)impulse {
    // Create sprite and add it to layer
    PhysicsSprite *ball = [PhysicsSprite
                spriteWithSpriteFrameName:@"ball.png"];
    ball.position = startPos;
    ball.tag = kBall;
    [bricksheet addChild:ball z:50];
    
    // Create ball body
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;
    ballBodyDef.position.Set(startPos.x/PTM_RATIO, 
                             startPos.y/PTM_RATIO);
    ballBodyDef.userData = ball;
    b2Body *ballBody = world->CreateBody(&ballBodyDef);
    
    // Link the body to the sprite
    [ball setPhysicsBody:ballBody];
    
    //Create a circle shape
    b2CircleShape circle;
    circle.m_radius = 7.0/PTM_RATIO;
    
    //Create fixture definition and add to body
    b2FixtureDef ballFixtureDef;
    ballFixtureDef.shape = &circle;
    ballFixtureDef.density = 1.0f;
    ballFixtureDef.friction = 0.0f;
    ballFixtureDef.restitution = 1.0f;

    ballBody->CreateFixture(&ballFixtureDef);
    ballBody->ApplyLinearImpulse(impulse,
                                 ballBody->GetPosition());
    isBallInPlay = YES;
}

-(void) buildBricksWithPattern:(NSInteger)patternNum {
    // Load in the desired pattern
    NSString *pattID = [NSString stringWithFormat:
                        @"P%i",patternNum];
    NSArray *tmpPattern = [patternDefs objectForKey:pattID];
    
    // We start at row 1
    NSInteger rowNum = 1;
    
    // Build each row of bricks
    for (NSString *aRow in tmpPattern) {
        [self buildBricksForRow:rowNum withString:aRow];
        rowNum++;
    }
}

-(void) buildBricksForRow:(NSInteger)rowNum
                    withString:(NSString*)brickString {
    for(int i = 0; i < [brickString length]; i++) {
        // Create brick and add it to the layer
        NSRange rng = NSMakeRange(i, 1);
        NSInteger newID = [[brickString
                substringWithRange:rng] integerValue];
        
        if (newID > 0) {
            NSString *newBrickName = [NSString
                stringWithFormat:@"brick%i.png", newID];
            
            PhysicsSprite *brick = [PhysicsSprite
                spriteWithSpriteFrameName:newBrickName];
            CGPoint startPos = [self positionForBrick:brick
                forRow:rowNum andColumn:i];
            
            brick.position = startPos;
            brick.tag = kBrick;
            [bricksheet addChild:brick z:10];
            
            // Create brick body
            b2BodyDef brickBodyDef;
            brickBodyDef.type = b2_dynamicBody;
            brickBodyDef.position.Set(startPos.x/PTM_RATIO,
                                      startPos.y/PTM_RATIO);
            brickBodyDef.userData = brick;
            b2Body *brickBody =
                        world->CreateBody(&brickBodyDef);
            
            [brick setPhysicsBody:brickBody];
            
            // Create brick shape
            b2PolygonShape brickShape;
            brickShape.SetAsBox(
                brick.contentSize.width/PTM_RATIO/2,
                brick.contentSize.height/PTM_RATIO/2);
            
            //Create shape definition, add to body
            b2FixtureDef brickShapeDef;
            brickShapeDef.shape = &brickShape;
            brickShapeDef.density = 200.0;
            brickShapeDef.friction = 0.0;
            brickShapeDef.restitution = 1.0f;
            brickBody->CreateFixture(&brickShapeDef);
        }
    }
}

-(void) buildPowerupAtPosition:(CGPoint)startPos {
    NSInteger powerupType = arc4random() % 3;
    NSString *powerupImageName;
    NSInteger newTag;
    
    switch (powerupType) {
        case 1:
            powerupImageName = @"powerup_contract.png";
            newTag = kPowerupContract;
            break;
        case 2:
            powerupImageName = @"powerup_multi.png";
            newTag = kPowerupMultiball;
            break;
        default:
            powerupImageName = @"powerup_expand.png";
            newTag = kPowerupExpand;
            break;
    }
    
    // Create sprite and add it to layer
    PhysicsSprite *powerup = [PhysicsSprite
            spriteWithSpriteFrameName:powerupImageName];
    powerup.position = startPos;
    powerup.tag = newTag;
    [bricksheet addChild:powerup z:50];
    
    // Create body
    b2BodyDef powerupBodyDef;
    powerupBodyDef.type = b2_dynamicBody;
    powerupBodyDef.position.Set(startPos.x/PTM_RATIO, 
                             startPos.y/PTM_RATIO);
    powerupBodyDef.userData = powerup;
    b2Body *powerupBody = world->CreateBody(&powerupBodyDef);
    
    // Connect the body to the sprite
    [powerup setPhysicsBody:powerupBody];
    
    // Define the fixture shape
    b2PolygonShape powerupShape;
    int num = 8;
    b2Vec2 verts[] = {
        b2Vec2(-5.6f / PTM_RATIO, 4.3f / PTM_RATIO),
        b2Vec2(-5.6f / PTM_RATIO, -4.6f / PTM_RATIO),
        b2Vec2(-4.3f / PTM_RATIO, -5.8f / PTM_RATIO),
        b2Vec2(4.5f / PTM_RATIO, -5.8f / PTM_RATIO),
        b2Vec2(5.5f / PTM_RATIO, -4.8f / PTM_RATIO),
        b2Vec2(5.5f / PTM_RATIO, 4.4f / PTM_RATIO),
        b2Vec2(4.5f / PTM_RATIO, 5.6f / PTM_RATIO),
        b2Vec2(-4.7f / PTM_RATIO, 5.6f / PTM_RATIO)
    };
    powerupShape.Set(verts, num);
    
    //Create shape definition and add to body
    b2FixtureDef powerupShapeDef;
    powerupShapeDef.shape = &powerupShape;
    powerupShapeDef.isSensor = YES;
    powerupBody->CreateFixture(&powerupShapeDef);
    
    b2Vec2 force = b2Vec2(0,-3);
    powerupBody->ApplyLinearImpulse(force,
                            powerupBodyDef.position);
}

-(void) newBall {
    [self buildBallAtStartingPosition:ccp(150,200)
                   withInitialImpulse:b2Vec2(0.2,-1.5)];
}

#pragma mark Update
-(void)update:(ccTime)dt {
	
	bool brickFound = FALSE;
	
    if (isPaddleDeformed) {
        paddleTimer = paddleTimer - dt;
        if (paddleTimer <= 0) {
            paddleTimer = 0;
            isPaddleDeformed = NO;
            [self buildPaddleFixtureNormal];
        }
    }
    
    // Step the world forward
	world->Step(dt, 10, 10);
    
    // Iterate through all bodies in the world
    for(b2Body *b = world->GetBodyList(); b;b=b->GetNext()) {
		if (b->GetUserData() != NULL) {
            // Get the sprite for this body
			PhysicsSprite *sprite =
                    (PhysicsSprite*)b->GetUserData();
            
            // Check if this sprite is a brick
			if (sprite.tag == kBrick) {
				brickFound = TRUE;
			}
			
            // Speed clamp for balls
            if (sprite.tag == kBall) {
				static int maxSpeed = 15;
                
				b2Vec2 velocity = b->GetLinearVelocity();
				float32 speed = velocity.Length();
				
				if (speed > maxSpeed) {
					b->SetLinearDamping(0.5);
				} else if (speed < maxSpeed) {
					b->SetLinearDamping(0.0);
				}
			}
		}
	}
    
    // Evaluate all contacts
    std::vector<b2Body *>toDestroy;
	std::vector<BRContact>::iterator pos;
	for (pos = contactListener->_contacts.begin();
		 pos != contactListener->_contacts.end(); pos++) {
		BRContact contact = *pos;
		
        // Get the bodies involved in this contact
		b2Body *bodyA = contact.fixtureA->GetBody();
		b2Body *bodyB = contact.fixtureB->GetBody();
        
        // Get the sprites attached to these bodies
        PhysicsSprite *spriteA =
                    (PhysicsSprite*)bodyA->GetUserData();
        PhysicsSprite *spriteB =
                    (PhysicsSprite*)bodyB->GetUserData();
        
        // Look for lost ball (off the bottom)
        if (spriteA.tag == kBall &&
            contact.fixtureB ==bottomGutter) {
            if (std::find(toDestroy.begin(),
                          toDestroy.end(), bodyA) ==
                          toDestroy.end()) {
                toDestroy.push_back(bodyA);
            }
        }
        // Look for lost ball (off the bottom)
        else if (contact.fixtureA == bottomGutter &&
                 spriteB.tag == kBall) {
            if (std::find(toDestroy.begin(),
                          toDestroy.end(), bodyB) ==
                          toDestroy.end()) {
                toDestroy.push_back(bodyB);
            }
        }

		else if (spriteA != NULL && spriteB != NULL) {
			// Sprite A = ball, Sprite B = Block
			if (spriteA.tag == kBall &&
                spriteB.tag == kBrick) {
				if (std::find(toDestroy.begin(),
                              toDestroy.end(), bodyB) ==
                              toDestroy.end()) {
					toDestroy.push_back(bodyB);
				}
			}
			
			// Sprite B = block, Sprite A = ball
			else if (spriteA.tag == kBrick &&
                     spriteB.tag == kBall) {
				if (std::find(toDestroy.begin(),
                              toDestroy.end(), bodyA) ==
                              toDestroy.end()) {
					toDestroy.push_back(bodyA);
				}
			}
            
            else if (spriteA.tag == kPowerupContract &&
                     spriteB.tag == kPaddle) {
				if (std::find(toDestroy.begin(),
                              toDestroy.end(), bodyA) ==
                              toDestroy.end()) {
					toDestroy.push_back(bodyA);
				}
            }
            
            else if (spriteA.tag == kPaddle &&
                     spriteB.tag == kPowerupContract) {
				if (std::find(toDestroy.begin(),
                              toDestroy.end(), bodyB) ==
                              toDestroy.end()) {
					toDestroy.push_back(bodyB);
				}
            }
            
            else if (spriteA.tag == kPowerupExpand &&
                     spriteB.tag == kPaddle) {
				if (std::find(toDestroy.begin(),
                              toDestroy.end(), bodyA) ==
                              toDestroy.end()) {
					toDestroy.push_back(bodyA);
				}
            }
            
            else if (spriteA.tag == kPaddle &&
                     spriteB.tag == kPowerupExpand) {
				if (std::find(toDestroy.begin(),
                              toDestroy.end(), bodyB) ==
                              toDestroy.end()) {
					toDestroy.push_back(bodyB);
				}
            }
            
            else if (spriteA.tag == kPowerupMultiball &&
                     spriteB.tag == kPaddle) {
				if (std::find(toDestroy.begin(),
                              toDestroy.end(), bodyA) ==
                              toDestroy.end()) {
					toDestroy.push_back(bodyA);
				}
            }
            
            else if (spriteA.tag == kPaddle &&
                     spriteB.tag == kPowerupMultiball) {
				if (std::find(toDestroy.begin(),
                              toDestroy.end(), bodyB) ==
                              toDestroy.end()) {
					toDestroy.push_back(bodyB);
				}
            }
            
            else if ((spriteA.tag == kPaddle &&
                      spriteB.tag == kBall) ||
                     (spriteA.tag == kBall &&
                      spriteB.tag == kPaddle)) {
                [[SimpleAudioEngine sharedEngine]
                                playEffect:SND_PADDLE];
            }
		}
	}
    
    // Destroy any bodies & sprites we need to get rid of
    std::vector<b2Body *>::iterator pos2;
    for(pos2 = toDestroy.begin(); pos2 != toDestroy.end();
                                            ++pos2) {
        b2Body *body = *pos2;
        if (body->GetUserData() != NULL) {
            PhysicsSprite *sprite =
                    (PhysicsSprite*)body->GetUserData();
            [self spriteDestroy:sprite];
        }
        world->DestroyBody(body);
    }
    
    // If no bricks found, they must all be destroyed
    if (!brickFound) {
        [self levelCompleteSplash];
    }
    
    if (shouldStartMultiball) {
        [self startMultiball];
        shouldStartMultiball = NO;
    }
}

-(void) spriteDestroy:(PhysicsSprite*)sprite {
    switch (sprite.tag) {
        case kBrick:
            [[SimpleAudioEngine sharedEngine]
                            playEffect:SND_BRICK];
            [self checkForRandomPowerupFromPosition:
                            sprite.position];
            [sprite removeFromParentAndCleanup:YES];
            [self addToScore:1];
            break;
        case kBall:
            [[SimpleAudioEngine sharedEngine]
                                playEffect:SND_LOSEBALL];
            [sprite removeFromParentAndCleanup:YES];
            [self loseLife];
            break;
        case kPowerupContract:
            [sprite removeFromParentAndCleanup:YES];
            [self buildPaddleFixtureShort];
            paddleTimer = 10; // Set the timer to 10 seconds
            isPaddleDeformed = YES;
            break;
        case kPowerupExpand:
            [sprite removeFromParentAndCleanup:YES];
            [self buildPaddleFixtureLong];
            paddleTimer = 10; // Set the timer to 10 seconds
            isPaddleDeformed = YES;
            break;
        case kPowerupMultiball:
            [sprite removeFromParentAndCleanup:YES];
            shouldStartMultiball = YES;
            break;            
    }
}

#pragma mark Powerups
-(void) checkForRandomPowerupFromPosition:(CGPoint)brickPos {
    // This will randomize a number.  There is a percentage chance
    // that a random powerup will drop from this brick
    // position.
    NSInteger rnd = arc4random() % 100;
    
    if (rnd < 25) {  /// 25 % CHANCE
        [self buildPowerupAtPosition:brickPos];
    }
}

-(void) startMultiball {
    // Prevent triggering a multiball when the ball is lost
    if (!isBallInPlay) {
        return;
    }
    CGPoint startPos;
    for(b2Body *b = world->GetBodyList(); b;b=b->GetNext()) {
		if (b->GetUserData() != NULL) {
            // Get the sprite for this body
			CCSprite *sprite = (CCSprite *)b->GetUserData();
            
            if (sprite.tag == kBall) {
                startPos = sprite.position;
                
                // Build 2 new balls at the same position, but
                // give them different impulses so they
                // go different directions
                
                [self buildBallAtStartingPosition:startPos
                    withInitialImpulse:b2Vec2(0.2,1.5)];
                [self buildBallAtStartingPosition:startPos
                    withInitialImpulse:b2Vec2(-0.2,1.5)];
                
                multiballCounter = multiballCounter + 2;
                
                // We break out to avoid chain reactions of
                // way too many balls at once
                break;
            }
        }
    }
}

#pragma mark Level Spashes
-(void) levelStartSplash {
    NSString *levelName = [NSString stringWithFormat:
                    @"Level %i", [gh currentLevel]];
    
    levelLabel = [CCLabelTTF labelWithString:levelName
                    fontName:@"Alpha Echo" fontSize:30];
    [levelLabel setColor:ccBLUE];
    [levelLabel setPosition:ccp(size.width/2,
                                size.height/2)];
    [self addChild:levelLabel z:10];
    
    [self scheduleOnce:@selector(destroyLevelSplash)
                                delay:1.0];
}

-(void) levelCompleteSplash {
    [self unscheduleUpdate];
    
    levelLabel = [CCLabelTTF labelWithString:@"Level Complete"
                    fontName:@"Alpha Echo" fontSize:30];
    [levelLabel setColor:ccBLUE];
    [levelLabel setPosition:ccp(size.width/2,
                                size.height/2)];
    [self addChild:levelLabel z:10];

    [self scheduleOnce:@selector(prepareForTransition)
                                delay:1.0];
}

-(void) destroyLevelSplash {
    [levelLabel removeFromParentAndCleanup:YES];
    
    [self startGame];
}

#pragma mark HUD Handling
-(void) addToScore:(NSInteger)newPoints {
    [hudLayer addToScore:newPoints];
}

-(void) loseLife {
    if (multiballCounter > 0) {
        multiballCounter--;
    } else {
        isBallInPlay = NO;
        
        [hudLayer loseLife];
        // Do we need another ball?
        if ([gh currentLives] > 0) {
            [self scheduleOnce:@selector(newBall) delay:1.0];
        } else {
            // Game over
            [self prepareForGameOver];
        }
    }
}

-(void) createHUD {
    hudLayer = [BRHUD node];
    [hudLayer setPosition:ccpAdd(hudLayer.position,
                                 ccp(0,size.height/2))];
    [self addChild: hudLayer z:10];
    [self hudFlyIn];
}

-(void) destroyHUD {
    [self hudFlyOut];
    [self scheduleOnce:@selector(removeHUDFromParent)
                                        delay:0.7];
}

-(void) removeHUDFromParent {
    [hudLayer removeFromParentAndCleanup:YES];
}

-(void) hudFlyIn {
    CCMoveBy *flyIn = [CCMoveBy actionWithDuration:0.5
                        position:ccp(0,-size.height/2)];
    [hudLayer runAction:flyIn];
}

-(void) hudFlyOut {
    CCMoveTo *flyOut = [CCMoveTo actionWithDuration:0.5
                        position:ccpAdd(hudLayer.position,
                        ccp(0,size.height/2))];
    [hudLayer runAction:flyOut];
}

#pragma mark Touch Handlers
-(void)ccTouchesBegan:(NSSet *)touches
                    withEvent:(UIEvent *)event {
	if (mouseJoint != NULL) return;
	
	UITouch *myTouch = [touches anyObject];
	CGPoint location = [myTouch locationInView:[myTouch view]];
	location = [[CCDirector sharedDirector]
                                convertToGL:location];
	b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO,
                                  location.y/PTM_RATIO);
	
    // We want our any touches in the bottom part of the
    // screen to control the paddle
    if (location.y < 150) {
		b2MouseJointDef md;
		md.bodyA = wallBody;
		md.bodyB = paddleBody;
		md.target = locationWorld;
		md.collideConnected = true;
		md.maxForce = 1000.0f * paddleBody->GetMass();
		
		mouseJoint = (b2MouseJoint *)world->CreateJoint(&md);
		paddleBody->SetAwake(true);
	}
}

-(void)ccTouchesMoved:(NSSet *)touches
                        withEvent:(UIEvent *)event {
    
	if (mouseJoint == NULL) return;
	
    if (isGameOver) return;
    
	UITouch *myTouch = [touches anyObject];
	CGPoint location = [myTouch locationInView:[myTouch view]];
	location = [[CCDirector sharedDirector]
                convertToGL:location];
	b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO,
                                  location.y/PTM_RATIO);
    
	mouseJoint->SetTarget(locationWorld);
}

-(void)ccTouchesCancelled:(NSSet *)touches
                withEvent:(UIEvent *)event {
	if(mouseJoint) {
		world->DestroyJoint(mouseJoint);
		mouseJoint = NULL;
	}
}

-(void)ccTouchesEnded:(NSSet *)touches
            withEvent:(UIEvent *)event {
    if (mouseJoint) {
        world->DestroyJoint(mouseJoint);
        mouseJoint = NULL;
    }
}

#pragma mark Object Positioning
-(CGPoint) positionForBrick:(CCSprite*)brickSprite
                     forRow:(NSInteger)rowNum
                  andColumn:(NSInteger)colNum {
    return ccp(22+(brickSprite.contentSize.width+1)*colNum,
        250+(rowNum * (brickSprite.contentSize.height+1))) ;
}

#pragma mark Level Complete
-(void) prepareForTransition {
    [self destroyHUD];
    [self scheduleOnce:@selector(goToNextLevel) delay:1.0];
}

-(void) goToNextLevel {
    [gh setCurrentLevel:[gh currentLevel]+1];
    [[CCDirector sharedDirector]
                replaceScene:[BRPlayfieldScene scene]];
}

#pragma mark Game Over
-(void) prepareForGameOver {
    isGameOver = YES;
    
    levelLabel = [CCLabelTTF labelWithString:@"Game Over"
                    fontName:@"Alpha Echo" fontSize:30];
    [levelLabel setColor:ccRED];
    [levelLabel setPosition:ccp(size.width/2,
                                size.height/2)];
    [self addChild:levelLabel z:10];
    
    [self scheduleOnce:@selector(gameOver) delay:3.0];
}

-(void) gameOver {

    [gh resetGame];
    
    [[CCDirector sharedDirector]
                    replaceScene:[BRMenuScene scene]];
}

@end
