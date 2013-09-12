//
//  SNPlayfieldLayer.m
//  ch4-snake
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "SNPlayfieldLayer.h"

@implementation SNPlayfieldLayer

+(id) initForLevel:(NSInteger)startLevel
     andDifficulty:(SNSkillLevel)skillLevel {
            return [[[self alloc]initForLevel:startLevel
                  andDifficulty:skillLevel] autorelease];
}

-(id) initForLevel:(NSInteger)startLevel
     andDifficulty:(SNSkillLevel)skillLevel {
	
    if (self = [super init]) {
        
        self.isTouchEnabled = YES;
        
        size = [[CCDirector sharedDirector] winSize];
        
        // Store the passed variables so we can use them later
        levelNum = startLevel;
        currentSkill = skillLevel;
        
        // Load the spritesheet
        [[CCSpriteFrameCache sharedSpriteFrameCache]
            addSpriteFramesWithFile:@"snakesheet.plist"];
        snakesheet = [CCSpriteBatchNode
                  batchNodeWithFile:@"snakesheet.png"];
        
        // Add the batch node to the layer
        [self addChild:snakesheet z:1];

        // Establish the arrays
        wallsOnField = [[NSMutableArray alloc] init];
        miceOnField = [[NSMutableArray alloc] init];
        deadMice = [[NSMutableArray alloc] initWithCapacity:1];
        
        // Create the snake & initialize parameters 
        [self createSnake];
        
        // Build the perimeter walls
        [self createOuterWalls];
        
        // Build the walls
        for (int i = 1; i <= wallCount; i++) {
            [self createWall];
        }

        // Build the initial mice
        for (int i = 1; i <= mouseCount; i++) {
            [self createMouse];
        }
        
        // Preload the sound effects
        [self preloadEffects];
        
        // Track the score (user never sees it)
        playerScore = 0;
    }
    
    return self;
}

-(void) dealloc {

    [snake release];
    [wallsOnField release];
    [miceOnField release];;
    [deadMice release];
    
    [super dealloc];
}

-(void) onEnterTransitionDidFinish {
    // On the first level, we show the instructions
    if (levelNum == 1) {
        isPaused = YES;
        [self showInstructions];
    // Subsequent levels skip instructions
    } else {
        isPaused = NO;
        [self showLevelSplash];
    }
}

#pragma mark Audio Setup
-(void) preloadEffects {
    [[SimpleAudioEngine sharedEngine]
                            preloadEffect:SND_CRASH];
    [[SimpleAudioEngine sharedEngine]
                            preloadEffect:SND_GULP];
}

#pragma mark Starting Instructions
-(void) showInstructions {
    // The odd spacing makes the text appear uniform between the two 
    // labels we create (the word right is wider, so we compensate with spaces)
    NSString *leftText =
        @"Touch the   left side of the screen to   turn left.";
    NSString *rightText =
        @"Touch the right side of the screen to turn right.";
    
    leftLabel = [CCLabelTTF labelWithString:leftText
        dimensions:CGSizeMake(size.width/4, size.height/2)
        hAlignment:UITextAlignmentCenter
        lineBreakMode:UILineBreakModeWordWrap
        fontName:@"Marker Felt"
        fontSize:22];
    [leftLabel setPosition:ccp(size.width/4, size.height/2)];
    [self addChild:leftLabel z:190];

    rightLabel = [CCLabelTTF labelWithString:rightText
        dimensions:CGSizeMake(size.width/4, size.height/2)
        hAlignment:UITextAlignmentCenter
        lineBreakMode:UILineBreakModeWordWrap
        fontName:@"Marker Felt"
        fontSize:22];
    [rightLabel setPosition:ccp(size.width - size.width/4,
                                size.height/2)];
    [self addChild:rightLabel z:190];
}
     
-(void) destroyInstructions {
    [leftLabel removeFromParentAndCleanup:YES];
    [rightLabel removeFromParentAndCleanup:YES];
    
    [self showLevelSplash];
}

#pragma mark Level Start & Complete
-(void) showLevelSplash {
    // We block user input
    preventTouches = YES;
    
    NSString *levelText = [NSString stringWithFormat:
                           @"Level %i", levelNum];
    
    levelLabel = [CCLabelTTF labelWithString:levelText 
                                fontName:@"Marker Felt"
                                fontSize:40];
    [levelLabel setColor:ccRED];
    [levelLabel setPosition:ccp(size.width/2,
                                size.height+100)];
    [self addChild:levelLabel z:200];
    
    CCMoveTo *moveIn = [CCMoveTo actionWithDuration:0.5
            position:ccp(size.width/2, size.height/2)];
    CCDelayTime *wait = [CCDelayTime actionWithDuration:1.0];
    CCMoveTo *moveOut = [CCMoveTo actionWithDuration:0.5
            position:ccp(size.width/2, size.height+100)];
    CCCallFunc *destroySplash = [CCCallFunc
            actionWithTarget:self
            selector:@selector(destroyLevelSplash)];
    CCCallFunc *startGame = [CCCallFunc
            actionWithTarget:self
            selector:@selector(startGame)];
    
    // Level number in, out, and then start the game
    [levelLabel runAction:[CCSequence actions:moveIn,
        wait, moveOut, destroySplash, startGame, nil]];
}

-(void) destroyLevelSplash {
    [levelLabel removeFromParentAndCleanup:YES];
}

-(void) showLevelComplete {
    // Unschedule the update
    [self unscheduleUpdate];
    
    // Prevent touches
    preventTouches = YES;
    
    NSString *levelText = @"Level Complete";
    
    CCLabelTTF *levelComplete = [CCLabelTTF
                                labelWithString:levelText
                                fontName:@"Marker Felt"
                                fontSize:40];
    [levelComplete setColor:ccGREEN];
    [levelComplete setPosition:ccp(0-size.width,
                                   size.height/2)];
    [self addChild:levelComplete z:200];

    CCMoveTo *moveIn = [CCMoveTo actionWithDuration:0.5 
            position:ccp(size.width/2, size.height/2)];
    CCDelayTime *wait = [CCDelayTime actionWithDuration:3.0];
    CCMoveTo *moveOut = [CCMoveTo actionWithDuration:0.5
            position:ccp(size.width*2, size.height/2)];
    CCCallFunc *goToNextLevel = [CCCallFunc
            actionWithTarget:self
            selector:@selector(goToNextLevel)];

    // Level complete label, then trigger the next level
    [levelComplete runAction:[CCSequence actions:moveIn,
            wait, moveOut, goToNextLevel, nil]];
}

-(void) goToNextLevel {
    // We pass the current level plus one, and skill level
    [[CCDirector sharedDirector] replaceScene:
        [SNPlayfieldScene sceneForLevel:levelNum + 1
                          andDifficulty:currentSkill]];
}

-(void) startGame {
    // We allow user interaction now
    preventTouches = NO;
    
    [self scheduleUpdate];
}

#pragma mark Update Method
-(void)update:(ccTime)dt {

    // stepTime controls the speed of movement
    stepTime += dt;
    
    // Lower snakeSpeed values = faster snake
    if (stepTime > snake.snakeSpeed) {
        
        // Reset the timer
        stepTime = 0;
        
        // Tell the snake to move
        [snake move];
        
        // Check for any object collisions
        [self checkForCollisions];
    }
    
    // Level complete after eating 8 mice
    if (playerScore >= 8) {
        [self showLevelComplete];
    }

    // Check for mice whose lifespan is over
    for (SNMouse *aMouse in miceOnField) {
        aMouse.lifespan = aMouse.lifespan - dt;
        
        // We use a second array so we don't try to mutate
        // the array while parsing it
        if (aMouse.lifespan <= 0) {
            [deadMice addObject:aMouse];
            [aMouse removeFromParentAndCleanup:YES];
        }
    }
    
    // Delete the dead mice from the miceOnField array
    [miceOnField removeObjectsInArray:deadMice];

    // Add new mice as replacements
    for (int i = 0; i < [deadMice count]; i++) {
        [self createMouse];
    }
    
    // Remove any dead mice
    [deadMice removeAllObjects];
}

#pragma mark Create Objects
-(void) createSnake {

    NSInteger snakeLength = 4 + currentSkill;
    
    // Create the snake
    snake = [[SNSnake createWithLayer:self
                        withLength:snakeLength] retain];
    
    // Establish the snake's speed
    snake.snakeSpeed = .3 -((levelNum+currentSkill)*0.02);

    // LEVEL INITIALIZATION PARAMETERS
    // These are here to centralize the level-based 
    // parameters, so it is easier to tweak the settings.
    wallCount = 3 + (levelNum * currentSkill);
    mouseCount = currentSkill;
}

-(void) createOuterWalls {
    // Left and Right edges of screen
    for (int row = 0; row <= size.height/gridSize+1; row++) {
        // Build a new wall on the left edge
        CGPoint newPosLeft = [self positionForRow:row
                                    andColumn:0];
        CCSprite *newWallLeft = [CCSprite
                spriteWithSpriteFrameName:@"wall.png"];
        [newWallLeft setPosition:newPosLeft];
        [self addChild:newWallLeft];
        [wallsOnField addObject:newWallLeft];

        // Build a new wall on the right edge
        CGPoint newPosRight = [self positionForRow:row
                andColumn:(size.width/gridSize)+1];
        CCSprite *newWallRight = [CCSprite
                spriteWithSpriteFrameName:@"wall.png"];
        [newWallRight setPosition:newPosRight];
        [self addChild:newWallRight];
        [wallsOnField addObject:newWallRight];
    }

    // Top and Bottom edges of screen
    for (int col = 1; col < size.width/gridSize; col++) {
        // Build a new wall at bottom edge of screen
        CGPoint newPosBott = [self positionForRow:0
                                    andColumn:col];
        CCSprite *newWallBottom = [CCSprite
                spriteWithSpriteFrameName:@"wall.png"];
        [newWallBottom setPosition:newPosBott];
        [self addChild:newWallBottom];
        [wallsOnField addObject:newWallBottom];

        // Build a new wall at the top edge of screen
        CGPoint newPosTop = [self positionForRow:
                (size.height/gridSize)+1 andColumn:col];
        CCSprite *newWallTop = [CCSprite
                spriteWithSpriteFrameName:@"wall.png"];
        [newWallTop setPosition:newPosTop];
        [self addChild:newWallTop];
        [wallsOnField addObject:newWallTop];
    }
}

-(void) createWall {
    BOOL approvedSpot = YES;
    // Define the snake's "line of sight" so we
    // can avoid putting a wall in front of his
    // starting location
    SNSnakeSegment *head = [[snake snakebody] objectAtIndex:0];
    
    CGRect snakeline = CGRectMake(head.boundingBox.origin.x - 
        head.contentSize.width/2, 0,
        head.boundingBox.origin.x + head.contentSize.width/2, 
        size.height);
    
    // Randomly generate a position
    NSInteger newRow = CCRANDOM_0_1()*(size.height/gridSize);
    NSInteger newCol = CCRANDOM_0_1()*(size.width/gridSize);
    
    CGPoint newPos = [self positionForRow:newRow
                                andColumn:newCol];
    
    // Build a new wall, add it to the layer
    CCSprite *newWall = [CCSprite
                spriteWithSpriteFrameName:@"wall.png"];
    [newWall setPosition:newPos];
    [self addChild:newWall];
    
    // Check to make sure we aren't on top of the snake
    for (SNSnakeSegment *aSeg in [snake snakebody]) {
        if (CGRectIntersectsRect([newWall boundingBox],
                                 [aSeg boundingBox])) {
            approvedSpot = NO;
            break;
        }
    }
    
    // Checks for a clear path in front of the snake
    // Assumes the snake is facing up
    if (CGRectIntersectsRect([newWall boundingBox],
                             snakeline)) {
        approvedSpot = NO;
    }
    
    // Check to make sure there are no walls overlapping
    for (CCSprite *aWall in wallsOnField) {
        if (CGRectIntersectsRect([newWall boundingBox],
                                 [aWall boundingBox])) {
            approvedSpot = NO;
            break;
        }
    }
    
    // Check to make sure there are no mice in the way
    for (CCSprite *aMouse in miceOnField) {
        if (CGRectIntersectsRect([newWall boundingBox],
                                 [aMouse boundingBox])) {
            approvedSpot = NO;
            break;
        }
    }
    
    // If we passed everything, keep the wall
    if (approvedSpot) {
        [wallsOnField addObject:newWall];
    // If we detected an overlap, build a replacement
    } else {
        [self removeChild:newWall cleanup:YES];
        [self createWall];
        return;
    }
}
    
-(void) createMouse {
    BOOL approvedSpot = YES;
    
    // Randomly generate a position
    NSInteger newRow = CCRANDOM_0_1()*(size.height/gridSize);
    NSInteger newCol = CCRANDOM_0_1()*(size.width/gridSize);
    CGPoint newPos = [self positionForRow:newRow
                                andColumn:newCol];
    // Build a new mouse, add it to the layer
    SNMouse *newMouse = [SNMouse
                spriteWithSpriteFrameName:@"mouse.png"];
    [newMouse setPosition:newPos];
    [self addChild:newMouse];
    // Check to make sure we aren't on top of the snake
    for (SNSnakeSegment *aSeg in [snake snakebody]) {
        if (CGRectIntersectsRect([newMouse boundingBox],
                                 [aSeg boundingBox])) {
            approvedSpot = NO;
            break;
        }
    }
    // Check to make sure there are no walls here
    for (CCSprite *aWall in wallsOnField) {
        if (CGRectIntersectsRect([newMouse boundingBox],
                                 [aWall boundingBox])) {
            approvedSpot = NO;
            break;
        }
    }
    // Check to make sure there are no mice in the way
    for (SNMouse *aMouse in miceOnField) {
        if (CGRectIntersectsRect([newMouse boundingBox],
                                 [aMouse boundingBox])) {
            approvedSpot = NO;
            break;
        }
    }
    // If we passed everything, keep the mouse
    if (approvedSpot) {
        [miceOnField addObject:newMouse];
    // If we detected an overlap, build a replacement
    } else {
        [self removeChild:newMouse cleanup:YES];
        [self createMouse];
        return;
    }
}

#pragma mark Collision Handlers
-(void) checkForCollisions {
    // Get the head
    SNSnakeSegment *head = [[snake snakebody]
                                        objectAtIndex:0];
    // Check for collisions with the snake's body
    for (SNSnakeSegment *bodySeg in [snake snakebody]) {
        if (CGRectIntersectsRect([head boundingBox],
            [bodySeg boundingBox]) && head != bodySeg) {
            [self snakeCrash];
            break;
        }
    }
    // Check for collisions with the walls
    for (CCSprite *aWall in wallsOnField) {
        if (CGRectIntersectsRect([aWall boundingBox],
                                 [head boundingBox])) {
            [self snakeCrash];
            break;
        }
    }

    // Check for mice eaten
    CCSprite *mouseToEat;
    BOOL isMouseEaten = NO;

    for (CCSprite *aMouse in miceOnField) {
        if (CGRectIntersectsRect([head boundingBox],
                                 [aMouse boundingBox])) {
            isMouseEaten = YES;
            mouseToEat = aMouse;
            [[SimpleAudioEngine sharedEngine]
                                playEffect:SND_GULP];
            break;
        }
    }
    
    // We can only eat one mouse at a time, so we handle it
    // a little more simply than the additional array we use
    // in the update loop (for expired/dead mice)
    if (isMouseEaten) {
        // Replace the mouse, longer snake, score
        [mouseToEat removeFromParentAndCleanup:YES];
        [miceOnField removeObject:mouseToEat];
        [self createMouse];
        [snake addSegment];
        [self incrementScore];
    }
}

-(void) snakeCrash {
    // Snake is dead.  Stop the update loop.
    [self unscheduleUpdate];
    
    // Play the crash sound
    [[SimpleAudioEngine sharedEngine] playEffect:SND_CRASH];
    
    // Start the flashing death sequence
    [snake deathFlash];
    
    // Show the game over splash
    [self gameOverSplash];
}

#pragma mark Score Handlers
-(void) incrementScore {
    // Increment the score and update the display
    playerScore++;
}

-(void) gameOverSplash {
    
    preventTouches = YES;
    isGameOver = YES;
    
    // Add a basic Game Over text
    CCLabelTTF *gameOverLabel = [CCLabelTTF 
                                 labelWithString:@"Game Over" 
                                 fontName:@"Marker Felt"
                                 fontSize:60];
    [gameOverLabel setPosition:ccp(size.width/2, size.height/2)];
    [self addChild:gameOverLabel z:200];
    
    // Add a second Game Over text, as a simple drop shadow
    CCLabelTTF *gameOverLabelShadow = [CCLabelTTF 
                                       labelWithString:@"Game Over"
                                       fontName:@"Marker Felt"
                                       fontSize:60];
    [gameOverLabelShadow setPosition:ccp(size.width/2 - 4, size.height/2 - 4)];
    [gameOverLabelShadow setColor:ccBLACK];
    [self addChild:gameOverLabelShadow z:199];
    
    // Force the game to wait on the game over screen for 2 seconds
    CCDelayTime *wait = [CCDelayTime actionWithDuration:2.0];
    CCCallFunc *enableTouch = [CCCallFunc actionWithTarget:self
                                                  selector:@selector(allowTouches)];
    
    [self runAction:[CCSequence actions:wait, enableTouch, nil]];
}

-(void) allowTouches {
    preventTouches = NO;
}

#pragma mark Object Positions
-(CGPoint) positionForRow:(NSInteger)rowNum
                andColumn:(NSInteger)colNum {
    // Used by all objects in the game for positioning
    float newX = (colNum * gridSize) - 2;
    float newY = (rowNum * gridSize) - 4;
    
    return ccp(newX, newY);
}

#pragma mark onEnter/onExit
-(void)onEnter
{
    [[[CCDirector sharedDirector] touchDispatcher]
                addTargetedDelegate:self priority:0
                swallowsTouches:YES];
    
    [super onEnter];
}

-(void)onExit
{
    [[[CCDirector sharedDirector] touchDispatcher]
                removeDelegate:self];
    
    [super onExit];
}

#pragma mark Touch Handlers
-(BOOL) ccTouchBegan:(UITouch *)touch
           withEvent:(UIEvent *)event {
    
    CGPoint location = [touch locationInView:[touch view]];
    CGPoint convLoc = [[CCDirector sharedDirector]
                       convertToGL:location];
    
    // Block touches from being accepted if set
    if (preventTouches) {
        return NO;
    }
    
    // If game over, return to menu
    if (isGameOver) {
        [[CCDirector sharedDirector]
                replaceScene:[SNMenuScene node]];
        return YES;
    }
    
    // If it was paused during the instructions,
    // the first tap starts the game
    if (isPaused) {
        isPaused = NO;
        [self destroyInstructions];
        return YES;
    }

    if (convLoc.x < size.width/2) {
        // Touched left half of the screen
        [snake turnLeft];
        return YES;
    } else {
        // Touched right half of the screen
        [snake turnRight];
        return YES;
    }
        
    // If we failed to find any reason to track the touch, we ignore it.
    return NO;
}

@end
