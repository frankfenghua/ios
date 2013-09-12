//
//  ERPlayfieldLayer.m
//  ch9-run
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "ERPlayfieldLayer.h"
#import "ERMenuScene.h"

@implementation ERPlayfieldLayer

@synthesize isGameOver;
@synthesize preventTouches;

-(id) init {
    if(self = [super init]) {
        
        size = [[CCDirector sharedDirector] winSize];
        
        // Load the spritesheet
        [[CCSpriteFrameCache sharedSpriteFrameCache]
         addSpriteFramesWithFile:@"runnersheet.plist"];
        runnersheet = [CCSpriteBatchNode
                       batchNodeWithFile:@"runnersheet.png"];
        [self addChild:runnersheet z:-1];
        
        bulletArray = [[NSMutableArray alloc] init];
        grndArray = [[NSMutableArray alloc] init];
        enemyArray = [[NSMutableArray alloc] init];
        bulletsToDelete = [[NSMutableArray alloc] init];
        enemiesToDelete = [[NSMutableArray alloc] init];
        grndToDelete = [[NSMutableArray alloc] init];
        platformStack = [[NSMutableArray alloc] init];
        
        // Establish baseline values
        maxJumpTimer = 0.8f;
        tileSize = 50;
        scrollSpeed = 2.5f;
        distanceTravelled = 0;
        allowDoubleJump = YES;
        isScrolling = NO;
        distanceTravelled = 0;
        preventTouches = YES;
        isGameOver = NO;
        
        // Load the enemy animations
        [self loadEnemyAnimations];
        
        // Add the HUD layer
        hudLayer = [[ERHUDLayer alloc] init];
        [self addChild:hudLayer z:50];
        

        // Build the scrolling background layers
        background1 = [[ERBackground alloc] init];
        [background1 setAnchorPoint:ccp(0,0)];
        [background1 setPosition:ccp(0,0)];
        [background1 useDarkBG];
        [background1 setBgScrollSpeed:0.025];
        [self addChild:background1 z:-3];
        
        background2 = [[ERBackground alloc] init];
        [background2 setAnchorPoint:ccp(0,0)];
        [background2 setPosition:ccp(200,0)];
        [background2 setInitialOffset:ccp(200,0)];
        [background2 setBgScrollSpeed:0.1];
        [self addChild:background2 z:-2];

        // We add 2 runs of ground tiles to make sure
        // hero has a clear "starting zone"
        [self addGroundTileswithEnemies:NO];
        [self addGroundTileswithEnemies:NO];

        // Bring the hero in dramatically
        [self landHeroInShip];

    }
    return self;
}


#pragma mark Update Methods
-(void) update:(ccTime)dt {

    // Move the background layers
    [background1 update:dt];
    [background2 update:dt];
    
    // Update the hero
    [self updateHero:dt];

    // Update the enemies
    [self updateEnemies:dt];
    
    // Update the bullets
    [self updateBullets];
    
    // Move the tiles
    [self updateTiles];
    
    // Check for collisions
    [self checkCollisions];
}

-(void) updateHero:(ccTime)dt {
    CGPoint newPos = hero.position;
    
    BOOL isFalling = YES;
    
    // The hero is going up
    if (hero.state == kHeroJumping || hero.state == kHeroInAir) {
        jumpTimer = jumpTimer - dt;
        
        if (jumpTimer <= 0) {
            // Jump ending, descend
            [hero stateChangeTo:kHeroFalling];
        } else {
            // Apply a force up for the hero
            newPos = ccpAdd(hero.position, ccp(0,3));
        }
    }
    
    // If hero is falling, apply our gravity
    if (hero.state == kHeroFalling) {
        newPos = ccpAdd(hero.position, ccp(0,-3));
    }
    
    // Check if the hero is touching the ground
    for (ERTile *aTile in grndArray) {
        if (CGRectIntersectsRect(hero.footSensor, aTile.topSensor)) {
            // push hero up 1 point if hit feet hit the ground
            newPos = ccpAdd(hero.position, ccp(0,1));
            [hero stateChangeTo:kHeroRunning];
        }
        
        // See if the fall sensor detects anything below
        if (CGRectIntersectsRect(hero.fallSensor, aTile.topSensor)) {
            // Not falling
            isFalling = NO;
        }
    }
    
    // Check if hero should fall
    if (isFalling && hero.state == kHeroRunning) {
        [hero stateChangeTo:kHeroFalling];
    }
    
    // Move the hero
    [hero setPosition:newPos];
    
    // Check if hero has fallen off screen
    if (hero.position.y < -40) {
        [self gameOver];
    }
}

-(void) updateEnemies:(ccTime)dt {

    // Only update the enemies while scrolling
    if (isScrolling == NO) {
        return;
    }
    
    // Loop through all enemies
    for (EREnemy *anEnemy in enemyArray) {
        BOOL noGround = YES;
        
        // Check movement direction
        if (anEnemy.isMovingRight) {
            // Moving against the scroll
            [anEnemy setPosition:ccpAdd(anEnemy.position, ccp(-scrollSpeed + 2,0))];
        } else {
            // Moving with the scroll
            [anEnemy setPosition:ccpAdd(anEnemy.position, ccp(-scrollSpeed - 2,0))];
        }
        
        // Updates for walking enemies only
        if (anEnemy.isFlying == NO) {
            // Check if the enemy is touching the ground
            for (ERTile *aTile in grndArray) {
                // See if the sensor detects anything below
                if (CGRectIntersectsRect(anEnemy.fallSensor, aTile.topSensor)) {
                    // Ground is under foot
                    noGround = NO;
                }
            }
            
            // If there is no ground underfoot, turn around
            if (noGround) {
                if (anEnemy.isMovingRight) {
                    [anEnemy setIsMovingRight:NO];
                    [anEnemy setFlipX:NO];
                } else {
                    [anEnemy setIsMovingRight:YES];
                    [anEnemy setFlipX:YES];
                }
            }
        }
        
        // Enemy can shoot, with time delay
        if (anEnemy.shootTimer <= 0) {
            [anEnemy shoot];
            anEnemy.shootTimer = 2.0;
        } else {
            anEnemy.shootTimer = anEnemy.shootTimer - dt;
        }

        // Check for enemies off screen
        if (anEnemy.position.x < -50) {
            // If off-screen to the left, add to delete
            [enemiesToDelete addObject:anEnemy];
            [anEnemy removeFromParentAndCleanup:YES];
        }
    }
    
    // Remove deleted enemies from the array
    [enemyArray removeObjectsInArray:enemiesToDelete];
    [enemiesToDelete removeAllObjects];
}

-(void) updateBullets {
    for (ERBullet *bullet in bulletArray) {
        if (bullet.isShootingRight) {
            // Move the bullet right
            bullet.position = ccpAdd(bullet.position, ccp(10,0));
            
            // Remove bullets that are off the screen
            if (bullet.position.x > size.width) {
                [bulletsToDelete addObject:bullet];
                [bullet removeFromParentAndCleanup:YES];
            }
        } else {
            // Move the bullet left
            bullet.position = ccpAdd(bullet.position, ccp(-10,0));
            
            // Remove bullets that are off the screen
            if (bullet.position.x < 0) {
                [bulletsToDelete addObject:bullet];
                [bullet removeFromParentAndCleanup:YES];
            }
        }
    }
    
    // Remove deleted bullets from the array
    [bulletArray removeObjectsInArray:bulletsToDelete];
    [bulletsToDelete removeAllObjects];
}

-(void) updateTiles {
    //Update the ground position, if scrolling
    if (isScrolling) {
        for (CCSprite *aTile in grndArray) {
            [aTile setPosition:ccpAdd(aTile.position, ccp(-scrollSpeed,0))];
        }
        // Update HUD
        distanceTravelled = distanceTravelled + (scrollSpeed / 100);
        [hudLayer changeDistanceTo:distanceTravelled];
        
        // Speed up the scroll slowly
        scrollSpeed = scrollSpeed + 0.001;
    }

    // Reset the maxTileX value
    maxTileX = 0;
    
    // Check all tiles
    for (ERTile *aTile in grndArray) {
        // Check for tiles scrolled away
        if (aTile.position.x < -100) {
            [grndToDelete addObject:aTile];
            [aTile removeFromParentAndCleanup:YES];
        }
        
        // Check for the rightmost tiles
        if (aTile.position.x > maxTileX) {
            maxTileX = aTile.position.x;
        }
    }
    
    // Remove off-screen tiles
    [grndArray removeObjectsInArray:grndToDelete];
    [grndToDelete removeAllObjects];
    
    // Check if we need to add new tiles
    if (maxTileX < (size.width * 1.1)) {
        // Add a gap first
        [self addGapTiles];
    }
}


#pragma mark Collision Handler
-(void) checkCollisions {
    
    BOOL isHeroHit = NO;
    
    for (ERBullet *bullet in bulletArray) {
        // Enemy bullets
        if (bullet.isHeroBullet == NO) {
            if (CGRectIntersectsRect(hero.boundingBox, bullet.boundingBox)) {
                // Hero got hit
                [bulletsToDelete addObject:bullet];
                [bullet removeFromParentAndCleanup:YES];
                isHeroHit = YES;
                break;
            }
        } else {
            // Hero bullets
            
            // Check all enemies to see if they got hit
            for (EREnemy *anEnemy in enemyArray) {
                if (CGRectIntersectsRect(anEnemy.boundingBox, bullet.boundingBox)) {
                    [bulletsToDelete addObject:bullet];
                    [bullet removeFromParentAndCleanup:YES];
                    [enemiesToDelete addObject:anEnemy];
                    [anEnemy gotShot];
                    break;
                }
            }
        } 
    }

    // Check for enemy and hero collisions
    for (EREnemy *anEnemy in enemyArray) {
        if (CGRectIntersectsRect(anEnemy.boundingBox, hero.boundingBox)) {
            // Trigger the enemy's hit
            [enemiesToDelete addObject:anEnemy];
            [anEnemy gotShot];
            // Trigger the hero's hit
            isHeroHit = YES;
            break;
        }
    }
    
    // We process this here because there could be
    // multiple collisions with the hero
    if (isHeroHit) {
        [hero gotShot];
    }
    
    // Remove deleted bullets from the array
    [bulletArray removeObjectsInArray:bulletsToDelete];
    [bulletsToDelete removeAllObjects];
    
    // Remove deleted enemies from the array
    [enemyArray removeObjectsInArray:enemiesToDelete];
    [enemiesToDelete removeAllObjects];
}

#pragma mark Hero methods

-(void) landHeroInShip {
    CCSprite *ship = [CCSprite spriteWithSpriteFrameName:@"ship.png"];
    [ship setPosition:ccp(-50, 250)];
    [ship setRotation:90];
    [runnersheet addChild:ship z:10];
    
    [self addHeroAtPos:ship.position];
    
    // Ship animation
    CCMoveBy *moveShipIn = [CCMoveBy actionWithDuration:3.0 position:ccp(150, 0)];
    CCRotateTo *rotateShip = [CCRotateTo actionWithDuration:0.25 angle:0];
    CCDelayTime *delayShip = [CCDelayTime actionWithDuration:0.75];
    CCMoveBy *moveShipOut = [CCMoveBy actionWithDuration:0.5 position:ccp(0, 150)];
    CCCallBlock *destroyShip = [CCCallBlock actionWithBlock:^{
        [ship removeFromParentAndCleanup:YES];
    }];
    
    // Hero animation
    CCMoveBy *moveHero = [CCMoveBy actionWithDuration:3.0 position:ccp(150, 0)];
    CCDelayTime *delay = [CCDelayTime actionWithDuration:0.5];
    CCCallBlock *dropHero = [CCCallBlock actionWithBlock:^{
        [hero stateChangeTo:kHeroFalling];
        [self scheduleUpdate];
        isScrolling = YES;
        preventTouches = NO;
    }];
    
    // Run the animations
    [ship runAction:[CCSequence actions:moveShipIn, rotateShip, delayShip, moveShipOut, destroyShip, nil]];
    [hero runAction:[CCSequence actions:moveHero, delay, dropHero, nil]];
    
    // Play the ship entrance sound
    [[SimpleAudioEngine sharedEngine] playEffect:SND_SHIP];
}

-(void) addHeroAtPos:(CGPoint)pos  {
    hero = [ERHero spriteWithSpriteFrameName:@"hero_run1.png"];
    [hero setPosition:pos];
    [hero setPf:self];
    [runnersheet addChild:hero z:5];
    
    [hero loadAnimations];
}

-(void) addBullet:(ERBullet*) thisBullet {
    [runnersheet addChild:thisBullet z:3];
    
    [bulletArray addObject:thisBullet];
}

#pragma mark Enemy methods
-(void) loadEnemyAnimations {    
    // Build all walking enemy animations
    for (int i = 1; i <= 18; i++) {
        // Build the names for the image and animation
        NSString *root = [NSString stringWithFormat:
                          @"walk%i_", i];
        NSString *anim = [NSString stringWithFormat:
                          @"%@move", root];
        
        // Build the animation into the cache
        [self buildCacheAnimation:anim
                 forFrameNameRoot:root
                    withExtension:@".png"
                       frameCount:4 withDelay:0.1];
    }
    
    // Build all flying enemy animations
    for (int i = 1; i <= 12; i++) {
        // Build the names for the image and animation
        NSString *root = [NSString stringWithFormat:
                          @"fly%i_", i];
        NSString *anim = [NSString stringWithFormat:
                          @"%@move", root];
        
        // Build the animation into the cache
        [self buildCacheAnimation:anim
                 forFrameNameRoot:root
                    withExtension:@".png"
                       frameCount:4 withDelay:0.1];
    }
 }

-(void) addWalkingEnemyAtPosition:(CGPoint)pos {
    // Randomly select a walking enemy
    NSInteger enemyNo = (arc4random() % 18) + 1;
    
    // Build the name of the enemy
    NSString *enemyNm = [NSString stringWithFormat:@"walk%i", enemyNo];
    
    // Built the initial sprite frame name
    NSString *enemyFrame = [NSString stringWithFormat:@"%@_1.png", enemyNm];
    
    EREnemy *enemy = [EREnemy spriteWithSpriteFrameName:enemyFrame];
    [enemy setPosition:ccpAdd(pos, ccp(0, enemy.contentSize.height/2))];
    [enemy setIsMovingRight:NO];
    [enemy setFlipX:NO];
    [enemy setIsFlying:NO];
    [enemy setPf:self];
    
    // Add this enemy to the layer and the array
    [runnersheet addChild:enemy z:5];
    [enemyArray addObject:enemy];
    
    // Set the enemy in motion
    NSString *moveAnim = [NSString stringWithFormat:@"%@_move", enemyNm];
    CCAnimate *idle = [self getAnim:moveAnim];
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:idle];
    [enemy runAction:repeat];
}

-(void) addFlyingEnemyAtPosition:(CGPoint)pos {
    // Randomly select a walking enemy
    NSInteger enemyNo = (arc4random() % 12) + 1;
    
    // Build the name of the enemy
    NSString *enemyNm = [NSString stringWithFormat:@"fly%i", enemyNo];
    
    // Built the initial sprite frame name
    NSString *enemyFrame = [NSString stringWithFormat:@"%@_1.png", enemyNm];
    
    EREnemy *enemy = [EREnemy spriteWithSpriteFrameName:enemyFrame];
    [enemy setPosition:pos];
    [enemy setIsMovingRight:NO];
    [enemy setFlipX:NO];
    [enemy setIsFlying:YES];
    [enemy setPf:self];
    
    // Add this enemy to the layer and the array
    [runnersheet addChild:enemy z:5];
    [enemyArray addObject:enemy];
    
    // Set the enemy in motion
    NSString *moveAnim = [NSString stringWithFormat:@"%@_move", enemyNm];
    CCAnimate *idle = [self getAnim:moveAnim];
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:idle];
    [enemy runAction:repeat];
}


#pragma mark Ground 
-(void) addGapTiles {
    // Add spaces between tiles
    // Size of gap depends on current speed
    NSInteger gapRnd = arc4random() % 5;

    // Only create a gap some of the time
    if (gapRnd > 1) {
        // Largest gap allowed is 5 tiles
        NSInteger gapSize = MIN(5, scrollSpeed);
        
        // Determine which gap/water image to use
        NSInteger gapType = (arc4random() % 2) + 1;

        for (int w = 0; w < gapSize; w++) {
            // We make the water slightly narrower
            maxTileX = maxTileX + tileSize - 2;

            NSString *tileNm = [NSString stringWithFormat:@"gap%i.png", gapType];
            ERTile *tile = [ERTile spriteWithSpriteFrameName:tileNm];
            
            [tile setAnchorPoint:ccp(0.5,0)];

            // Put tile at bottom of screen
            [tile setPosition:ccp(maxTileX, 0)];
            
            // Gap tiles are not walkable
            [tile setIsTop:NO];
            
            [grndArray addObject:tile];
            [runnersheet addChild:tile z:-1];
        }
    }
    
    // 10 % chance of spawning a flying enemy
    if (arc4random() % 10 == 1) {
        float newY = (arc4random() % 40) + 250;
        [self addFlyingEnemyAtPosition:ccp(maxTileX, newY)];
    }
    // Always add more tiles after the gap
    [self addGroundTileswithEnemies:YES];
}

-(void) addGroundTileswithEnemies:(BOOL)haveEnemies {
    // Randomize nearly everything about the ground
    NSInteger platformWidth = (arc4random() % 5) + 2;
    NSInteger platformHeight = (arc4random() % 4) + 1;
    NSInteger platformType = (arc4random() % 3) + 1;

    switch (platformHeight) {
        case 1:
            [platformStack addObject:[NSNumber
                                      numberWithInt:3]];
            break;
        case 2:
            [platformStack addObject:[NSNumber
                                      numberWithInt:1]];
            [platformStack addObject:[NSNumber
                                      numberWithInt:3]];
            break;
        case 3:
            [platformStack addObject:[NSNumber
                                      numberWithInt:1]];
            [platformStack addObject:[NSNumber
                                      numberWithInt:2]];
            [platformStack addObject:[NSNumber
                                      numberWithInt:3]];
            break;
        case 4:
            [platformStack addObject:[NSNumber
                                      numberWithInt:1]];
            [platformStack addObject:[NSNumber
                                      numberWithInt:3]];
            [platformStack addObject:[NSNumber
                                      numberWithInt:2]];
            [platformStack addObject:[NSNumber
                                      numberWithInt:3]];
            break;
    }
    
    for (int w = 0; w <= platformWidth; w++) {
        // Set the new X position for the tile
        maxTileX = maxTileX + tileSize;
        
        for (int i = 0; i < platformHeight; i++) {

            NSInteger currentTile = [[platformStack objectAtIndex:i] integerValue];
            
            NSString *tileNm = [NSString stringWithFormat:@"w%i_%i.png", platformType, currentTile];
            ERTile *tile = [ERTile spriteWithSpriteFrameName:tileNm];

            // Determine where to position the tile
            [tile setAnchorPoint:ccp(0.5,0)];
            float newY = i * tileSize;
            
            // Identify if we need a walkable surface
            if (currentTile == 3) {
                [tile setIsTop:YES];
                
                // Do we want enemies to spawn here?
                if (haveEnemies) {
                    // Determine if we need an enemy here
                    if ((arc4random() % 13) < 1) {
                        // chance of an enemy walker
                        // Add it slightly above the ground
                        [self addWalkingEnemyAtPosition:
                         ccp(maxTileX, newY + tileSize)];
                    }
                }
            } else {
                [tile setIsTop:NO];
            }
            
            // Set the position (will also create sensor)
            [tile setPosition:ccp(maxTileX, newY)];
            
            [grndArray addObject:tile];
            [runnersheet addChild:tile z:currentTile];
        }
    }
    [platformStack removeAllObjects];
}


#pragma mark Game Over
-(void) gameOver {
    [self unscheduleUpdate];
    
    preventTouches = YES;
    isGameOver = YES;
    
    CCLabelTTF *gameOver = [CCLabelTTF labelWithString:@"Game Over" fontName:@"Verdana" fontSize:30];
    [gameOver setPosition:ccp(size.width/2, size.height/2)];
    [self addChild:gameOver z:5];
    
    CCDelayTime *delay = [CCDelayTime actionWithDuration:2.0f];
    CCCallBlock *resume = [CCCallBlock actionWithBlock:^{
        preventTouches = NO;
    }];
    
    [self runAction:[CCSequence actions:delay, resume, nil]];
}


#pragma mark Touch Handlers
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {

    if (preventTouches) {
        return YES;
    }
    
    if (isGameOver) {
        [[CCDirector sharedDirector] replaceScene:[ERMenuScene scene]];
        return YES;
    }
    
    
    CGPoint loc = [touch locationInView:[touch view]];
    CGPoint convLoc = [[CCDirector sharedDirector]
                       convertToGL:loc];
    
    if (convLoc.x < size.width/2) {
        // Jump if left side of screen
        if (hero.state == kHeroRunning) {
            // Jump from the ground
            [hero stateChangeTo:kHeroJumping];
            // Reset the jump timer
            jumpTimer = maxJumpTimer;
            // Allow hero to double-jump
            allowDoubleJump = YES;
        } else if (allowDoubleJump) {
            // Allow a second jump in the air
            [hero stateChangeTo:kHeroJumping];
            // Reset the jump timer
            jumpTimer = maxJumpTimer;
            // Prevent a third jump
            allowDoubleJump = NO;
        } else {
            return NO;
        }
    } else {
        // Shoot if right side of screen
        [hero shoot];
    }
    return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if (isGameOver) {
        return;
    }
    
    CGPoint loc = [touch locationInView:[touch view]];
    CGPoint convLoc = [[CCDirector sharedDirector]
                       convertToGL:loc];
    
    // Release the jump
    if (convLoc.x < size.width/2) {
        // Jump if left side of screen
        [hero stateChangeTo:kHeroFalling];
    }
}

#pragma Animation Loaders
-(CCAnimate*) getAnim:(NSString*)animNm {
    // Helper to avoid typing this long line repeaedly
    return [CCAnimate actionWithAnimation:
            [[CCAnimationCache sharedAnimationCache]
             animationByName:animNm]];
}

-(void)buildCacheAnimation:(NSString*) AnimName
          forFrameNameRoot:(NSString*) root
             withExtension:(NSString*) ext
                frameCount:(NSInteger) count
                 withDelay:(float)delay {
	// This method goes through all the steps to load an
    // animation to the CCSpriteFrameCache
	//
	// We can use them later by using:
	// [CCAnimate actionWithAnimation:[[CCAnimationCache
    // sharedAnimationCache] animationByName:
    // @"AnimName_Goes_Here"]];
	//
    
	NSMutableArray *frames = [NSMutableArray array];
    
	// Load the frames
	for(int i = 1; i <= count; i++) {
		CCSpriteFrame *newFrame = [[CCSpriteFrameCache
            sharedSpriteFrameCache] spriteFrameByName:
            [NSString stringWithFormat:@"%@%i%@",
            root, i, ext]];
		[frames addObject:newFrame];
	}
	// Build the animation
    CCAnimation *newAnim  =[CCAnimation
                        animationWithSpriteFrames:frames
                        delay:delay];
	// Store it in the cache
	[[CCAnimationCache sharedAnimationCache]
     addAnimation:newAnim name:AnimName];
}


#pragma mark Enter, Exit
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

    [bulletArray release];
    [grndArray release];
    [enemyArray release];
    [bulletsToDelete release];
    [enemiesToDelete release];
    [grndToDelete release];
    [platformStack release];
    
    [hudLayer release];
    
    [background1 release];
    [background2 release];
    
    [[[CCDirector sharedDirector] touchDispatcher]
     removeDelegate:self];
    
    [super onExit];
}

#pragma mark Debug Draws For Sensor Boxes
/*
-(void) drawBoundingBox: (CGRect) rect
{
    
    glLineWidth(1.0f);
    ccDrawColor4B(255, 0, 255, 255);
    CGPoint vertices[4]={
        ccp(rect.origin.x,rect.origin.y),
        ccp(rect.origin.x+rect.size.width,rect.origin.y),
        ccp(rect.origin.x+rect.size.width,rect.origin.y+rect.size.height),
        ccp(rect.origin.x,rect.origin.y+rect.size.height),
    };
    ccDrawPoly(vertices, 4, YES);
}

-(void) draw
{

    // Draw hero's sensors
    [self drawBoundingBox: hero.footSensor];
    [self drawBoundingBox:hero.fallSensor];
    
    // Draw enemy sensors
    for (EREnemy *anEnemy in enemyArray) {
        [self drawBoundingBox:anEnemy.fallSensor];
    }
    
    // Draw tile sensors
    for (ERTile *aTile in grndArray) {
        if (aTile.isTop) {
            [self drawBoundingBox:aTile.topSensor];
        }
    }
    
    [super draw];
}
*/

@end
