//
//  TDPlayfieldLayer.m
//  ch8-shooter
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "TDPlayfieldLayer.h"

@implementation TDPlayfieldLayer

@synthesize tileMap = _tileMap;
@synthesize ground = _ground;
@synthesize triggers = _triggers;
@synthesize pickups = _pickups;
@synthesize walls = _walls;
@synthesize hero = _hero;
@synthesize heroShooting;
@synthesize isGameOver;
@synthesize preventTouches;

+(id) layerWithHUDLayer:(TDHUDLayer*)hud {
    return [[[self alloc] initWithHUDLayer:hud] autorelease];
}

-(id) initWithHUDLayer:(TDHUDLayer*)hud {
    if(self = [super init]) {
        
        // Keep a reference to the HUD layer
        hudLayer = hud;
        
        size = [[CCDirector sharedDirector] winSize];
        
        // Load the spritesheet
        [[CCSpriteFrameCache sharedSpriteFrameCache]
           addSpriteFramesWithFile:@"desertsheet.plist"];
        desertsheet = [CCSpriteBatchNode
                   batchNodeWithFile:@"desertsheet.png"];
        [self addChild:desertsheet z:1];
    
        self.isTouchEnabled = YES;
        
        // Load the map
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:
                        @"desert_map.tmx"];
        self.ground = [_tileMap layerNamed:@"ground"];
        self.triggers = [_tileMap layerNamed:@"triggers"];
        self.pickups = [_tileMap layerNamed:@"pickups"];
        self.walls = [_tileMap layerNamed:@"walls"];
        self.triggers.visible = NO;
        self.walls.visible = NO;

        [self addChild:_tileMap z:-1];
        
        // Load the spawn object layer
        spawns = [_tileMap objectGroupNamed:@"spawns"];
        NSAssert(spawns != nil, @"'spawns' missing");
        
        // Initialize the arrays
        enemyArray = [[NSMutableArray alloc] init];
        bulletArray = [[NSMutableArray alloc] init];
        
        // Build the hero
        [self addHero];
        
        // Build the enemies
        [self addEnemies];
        
        // Center the layer on the player
        [self setViewpointCenter:hero.sprite.position];
        
        shootSpeed = 0.2;
        currHeroShootSpeed = 0;
        heroHealth = 100;
        heroGoalsRemaining = 3;
        heroKills = 0;
        isGameOver = NO;
        preventTouches = NO;
        
        [hudLayer changeHealthTo:heroHealth];
        [hudLayer changeGoalTo:heroGoalsRemaining];
        [hudLayer changeKillsTo:heroKills];

        // Shorthand for tilemap sizes, with retina fix
        tmw = _tileMap.mapSize.width;
        tmh = _tileMap.mapSize.height;
        tw = _tileMap.tileSize.width /
                            CC_CONTENT_SCALE_FACTOR();
        th = _tileMap.tileSize.height /
                            CC_CONTENT_SCALE_FACTOR();

        // Schedule the update
        [self scheduleUpdate];

    }
    return self;
}

#pragma mark Update And Collisions
-(void) update:(ccTime) dt {
    // If the shoot button is pressed
    if (heroShooting) {
        // We limit the hero's shoot speed to avoid
        // massive "bullet rain" effect
        if (currHeroShootSpeed > 0) {
            currHeroShootSpeed -= dt;
        } else {
            // Ready to shoot
            [hero shoot];
            currHeroShootSpeed = shootSpeed;
        }
    } else {
        // Get ready to shoot next press
        currHeroShootSpeed = 0;
    }
    
    // Move the enemies
    for (int i = 0; i < [enemyArray count]; i++) {
        [[enemyArray objectAtIndex:i] update:dt];
    }
    
    // Move the bullets
    for (int i = 0; i < [bulletArray count]; i++) {
        [[bulletArray objectAtIndex:i] update:dt];
    }
    
    // Check collisions
    [self checkCollisions];
    
    // Is the game over?
    if (isGameOver) {
        [self gameOver];
    }
}

-(void) checkCollisions {
    NSMutableArray *bulletsToDelete = [[NSMutableArray alloc] init];
    
    for (TDBullet *aBullet in bulletArray) {
        
        if (CGRectIntersectsRect(aBullet.boundingBox,
                                 hero.sprite.boundingBox)
                                && aBullet.isEnemy) {
            // Hero got hit!
            [self heroGetsHit];
            [bulletsToDelete addObject:aBullet];
            [aBullet removeFromParentAndCleanup:YES];
            break;
        }
        // Iterate through enemies, see if they got hit
        for (TDEnemy *anEnemy in enemyArray) {
            
            if (CGRectIntersectsRect(aBullet.boundingBox,
                                anEnemy.sprite.boundingBox)
                            && aBullet.isEnemy == NO) {
                //Enemy got hit
                [self enemyGetsHit:anEnemy];
                [bulletsToDelete addObject:aBullet];
                [aBullet removeFromParentAndCleanup:YES];
                break;
            }
        }
    }
    
    // Remove the bullets
    for (int i = 0; i < [bulletsToDelete count]; i++) {
        [bulletArray removeObjectsInArray:bulletsToDelete];
    }
    
    [bulletsToDelete release];
}

-(void)setViewpointCenter:(CGPoint) position {
    // Method written Ray Wenderlich
    // Posted at www.raywenderlich.com
    int x = MAX(position.x, size.width / 2);
    int y = MAX(position.y, size.height / 2);
    x = MIN(x, (_tileMap.mapSize.width *
                _tileMap.tileSize.width) - size.width / 2);
    y = MIN(y, (_tileMap.mapSize.height *
                _tileMap.tileSize.height) - size.height/2);
    CGPoint actualPosition = ccp(x, y);
    CGPoint centerOfView = ccp(size.width/2,
                               size.height/2);
    CGPoint viewPoint = ccpSub(centerOfView,
                               actualPosition);
    self.position = viewPoint;
}

-(void)applyJoystick:(SneakyJoystick*)joystick
              toNode:(CCSprite*)sprite
        forTimeDelta:(float)delta {
    
    // Scale up the joystick's reading to faster movement
	CGPoint scaledVelocity = ccpMult(joystick.velocity,
                                     200);
    
    // Apply the scaled velocity to the position
    float newPosX = hero.sprite.position.x +
                        scaledVelocity.x * delta;
    float newPosY = hero.sprite.position.y +
                        scaledVelocity.y * delta;
    CGPoint newPos = ccp(newPosX, newPosY);
    
    // Rotate the hero
    [hero rotateToTarget:newPos];

    // Set the new position
    [self setHeroPos:newPos];
}

-(void) setHeroPos:(CGPoint)pos {
    // Get the tile coordinates
    CGPoint tileCoord = [self tileCoordForPos:pos];

    // Check if the new tile is blocked
    if ([self isWallAtTileCoord:tileCoord]) {
        // Return without allowing the move
        return;
    }

    // Check if the hero picked up health
    if ([self isHealthAtTileCoord:tileCoord]) {
        // Remove it from the map
        [_triggers removeTileAt:tileCoord];
        [_pickups removeTileAt:tileCoord];
        // Add health to the player
        [self heroGetsHealth];
    }

    // Check if the hero grabbed a goal
    if ([self isGoalAtTileCoord:tileCoord]) {
        // Remove it from the map
        [_triggers removeTileAt:tileCoord];
        [_pickups removeTileAt:tileCoord];
        // Add goal to the player
        [self heroGetsGoal];
    }

    // Set the new position
    hero.sprite.position = pos;
    
    // Center the view on the hero
    [self setViewpointCenter:pos];
}

-(CGPoint) getHeroPos {
    return hero.sprite.position;
}

-(void) rotateHeroToward:(CGPoint)target {
    [hero rotateToTarget:target];
}

#pragma mark Hero
-(void) addHero {
    // Get the player spawn location
    NSMutableDictionary *playerSpawn =
                    [spawns objectNamed:@"playerSpawn"];
    NSAssert(playerSpawn != nil, @"playerSpawn missing");
    int x = [[playerSpawn valueForKey:@"x"] intValue];
    int y = [[playerSpawn valueForKey:@"y"] intValue];
    CGPoint heroPos = ccp(x / CC_CONTENT_SCALE_FACTOR(),
                          y / CC_CONTENT_SCALE_FACTOR());
    
    // Create the player
    hero = [TDHero heroAtPos:heroPos onLayer:self];
    [self addChild:hero];
}

-(void) heroGetsHealth {
    heroHealth = heroHealth + 40;
    [hudLayer changeHealthTo:heroHealth];
}

-(void) heroGetsGoal {
    heroGoalsRemaining--;
    [hudLayer changeGoalTo:heroGoalsRemaining];
    
    if (heroGoalsRemaining <= 0) {
        // hero wins
        isGameOver = YES;
        preventTouches = YES;
    }
}

-(void) heroGetsHit {
    // Decrease the hero's health
    heroHealth = heroHealth - 20;
    [hudLayer changeHealthTo:heroHealth];
    
    // Play the effect
    [[SimpleAudioEngine sharedEngine] playEffect:SND_HERO];
    
    if (heroHealth <= 0) {
        // Hero died.
        isGameOver = YES;
        preventTouches = YES;
    }
}

#pragma mark Enemy Handling
-(void) addEnemies {
    // Add some enemies
    for (int i = 0; i < 5; i++) {
        [self addEnemyOfType:kEnemyEasy];
    }
    
    for (int i = 0; i < 3; i++) {
        [self addEnemyOfType:kEnemyHard];
    }
}

-(void) addEnemyOfType:(EnemyType)enemyType {
    // Randomly pick a spawn point
    NSString *enemySpawnID = [NSString stringWithFormat:
                              @"EnemySpawn%i",
                              (arc4random() % 11) + 1];

    // Get the point
    NSMutableDictionary *enemySpawn = [spawns objectNamed:
                                       enemySpawnID];
    float x = [[enemySpawn valueForKey:@"x"] floatValue];
    float y = [[enemySpawn valueForKey:@"y"] floatValue];
    
    // Retina-ize the position (TMX files are in pixels)
    x /= CC_CONTENT_SCALE_FACTOR();
    y /= CC_CONTENT_SCALE_FACTOR();
    
    if (enemyType == kEnemyEasy) {
        // Create the enemy (will put itself on the layer)
        TDEnemy *enemy = [TDEnemy enemyAtPos:ccp(x,y)
                                     onLayer:self];
        
        // Add it to the array
        [enemyArray addObject:enemy];
    }
    else if (enemyType == kEnemyHard) {
        // Create the enemy (will put itself on the layer)
        TDEnemySmart *enemy = [TDEnemySmart
                               enemyAtPos:ccp(x,y)
                               onLayer:self];
        
        // Add it to the array
        [enemyArray addObject:enemy];
    }
}

-(void) enemyGetsHit:(TDEnemy*) thisEnemy {
    // Get rid of the enemy
    [thisEnemy.sprite removeFromParentAndCleanup:YES];
    [enemyArray removeObject:thisEnemy];
    
    // Score the kill
    heroKills++;
    [hudLayer changeKillsTo:heroKills];
    
    // Play the effect
    [[SimpleAudioEngine sharedEngine] playEffect:SND_ENEMY];

    // Spawn a new enemy to replace this one
    [self addEnemyOfType:kEnemyEasy];
}

#pragma mark Bullet Handling
-(void) addBullet:(TDBullet*)thisBullet {
    [self addChild:thisBullet z:5];
    [bulletArray addObject:thisBullet];
}

-(void) removeBullet:(TDBullet*)thisBullet {
    [thisBullet setIsDead:YES];
    [bulletArray removeObject:thisBullet];
    [thisBullet removeFromParentAndCleanup:YES];
}

#pragma mark Game Over
-(void) gameOver {

    [self unscheduleUpdate];
    
    NSString *msg = @"You win!";
    
    if (heroHealth <= 0) {
        msg = @"You died.";
    }
    
    [hudLayer showGameOver:msg];
        
    CCDelayTime *delay = [CCDelayTime actionWithDuration:3.0];
    CCCallBlock *allowExit = [CCCallBlock actionWithBlock:^{
        preventTouches = NO;
    }];
    
    [self runAction:[CCSequence actions: delay, allowExit,
                     nil]];
}

#pragma mark Tile Methods
-(CGPoint)tileCoordForPos:(CGPoint)pos {
    // Convert map posiiton to tile coordinate
    NSInteger x = pos.x / tw;
    NSInteger y = ((tmh * th) - pos.y) / th;
    
    return ccp(x,y);
}

- (CGPoint)posForTileCoord:(CGPoint)tileCoord {
    // Convert the tile coordinate to map position
    NSInteger x = (tileCoord.x * tw) + tw / 2;
    NSInteger y = (tmh * th)-(tileCoord.y * th)-th / 2;

    return ccp(x, y);
}

#pragma mark Tile And Pathfinding
- (BOOL)isValidTileCoord:(CGPoint)tileCoord {
    if (tileCoord.x < 0 || tileCoord.y < 0 ||
        tileCoord.x >= tmw ||
        tileCoord.y >= tmh) {
        return FALSE;
    } else {
        return TRUE;
    }
}

-(BOOL)isWallAtTileCoord:(CGPoint)tileCoord {
    // If it is invalid, act like it is a wall
    if ([self isValidTileCoord:tileCoord] == NO) {
        return YES;
    }
    
    int gid = [self.walls tileGIDAt:tileCoord];
    NSDictionary *properties = [_tileMap
                                propertiesForGID:gid];

    return ([properties valueForKey:@"Blocked"] != nil);
}

-(BOOL)isGoalAtTileCoord:(CGPoint)tileCoord {
    int gid = [self.triggers tileGIDAt:tileCoord];
    NSDictionary *properties = [_tileMap
                                propertiesForGID:gid];
    
    return ([properties valueForKey:@"Goal"] != nil);
}

-(BOOL)isHealthAtTileCoord:(CGPoint)tileCoord {
    int gid = [self.triggers tileGIDAt:tileCoord];
    NSDictionary *properties = [_tileMap
                                propertiesForGID:gid];

    return ([properties valueForKey:@"Health"] != nil);
}

#pragma mark A* Pathfinding
- (NSArray *)walkableAdjacentTilesCoordForTileCoord:(CGPoint)tileCoord
{
    // Code from Johann Fradj
    // Published at www.raywenderlich.com
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:8];
    
    BOOL t = NO;
    BOOL l = NO;
    BOOL b = NO;
    BOOL r = NO;
	
	// Top
	CGPoint p = CGPointMake(tileCoord.x, tileCoord.y - 1);
	if ([self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
        t = YES;
	}
	
	// Left
	p = CGPointMake(tileCoord.x - 1, tileCoord.y);
	if ([self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
        l = YES;
	}
	
	// Bottom
	p = CGPointMake(tileCoord.x, tileCoord.y + 1);
	if ([self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
        b = YES;
	}
	
	// Right
	p = CGPointMake(tileCoord.x + 1, tileCoord.y);
	if ([self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
        r = YES;
	}
    
    
	// Top Left
	p = CGPointMake(tileCoord.x - 1, tileCoord.y - 1);
	if (t && l && [self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
	
	// Bottom Left
	p = CGPointMake(tileCoord.x - 1, tileCoord.y + 1);
	if (b && l && [self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
	
	// Top Right
	p = CGPointMake(tileCoord.x + 1, tileCoord.y - 1);
	if (t && r && [self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
	
	// Bottom Right
	p = CGPointMake(tileCoord.x + 1, tileCoord.y + 1);
	if (b && r && [self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
    
    
	return [NSArray arrayWithArray:tmp];
}

#pragma mark Exit and Dealloc
-(void)onExit
{
    [enemyArray release];
    [bulletArray release];
    [controls release];

    [super onExit];
}

-(void) dealloc {
    
    self.tileMap = nil;
    self.ground = nil;
    self.triggers = nil;
    self.pickups = nil;
    self.walls = nil;
    
    [super dealloc];
}

@end
