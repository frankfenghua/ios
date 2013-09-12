//
//  MTPlayfieldLayer.m
//  ch1-memory
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "MTPlayfieldLayer.h"

#define SND_TILE_FLIP @"button.caf"
#define SND_TILE_SCORE @"whoosh.caf"
#define SND_TILE_WRONG @"buzzer.caf"
#define SND_SCORE @"harprun.caf"

@implementation MTPlayfieldLayer

#pragma mark Build and Teardown Methods
+(id) layerWithRows:(NSInteger)numRows
         andColumns:(NSInteger)numCols {
	return [[[self alloc] initWithRows:numRows
                    andColumns:numCols] autorelease];
}

-(id) initWithRows:(NSInteger)numRows
        andColumns:(NSInteger)numCols {
	
    if (self == [super init]) {
        
        self.isTouchEnabled = YES;
        
        // Get the window size from the CCDirector
        size = [[CCDirector sharedDirector] winSize];
        
        // Preload the sound effects
        [self preloadEffects];
        
        // make sure we've loaded the spritesheets
        [[CCSpriteFrameCache sharedSpriteFrameCache]
         addSpriteFramesWithFile:@"memorysheet.plist"];
        memorysheet = [CCSpriteBatchNode
                batchNodeWithFile:@"memorysheet.png"];
        
        // Add the batch node to the layer
        [self addChild:memorysheet];
        
        // Add the back Button to the bottom right corner
        backButton = [CCSprite spriteWithSpriteFrameName:
                      @"backbutton.png"];
        [backButton setAnchorPoint:ccp(1,0)];
        [backButton setPosition:ccp(size.width - 10, 10)];
        [memorysheet addChild:backButton];
        
        // Maximum size of the actual playing field
        boardWidth = 400;
        boardHeight = 320;
        
        // Set the board rows and columns
        boardRows = numRows;
        boardColumns = numCols;
        
        // If the total number of tile positions is
        // not even, remove one row
        // This protects against an impossible board
        if ( (boardRows * boardColumns) % 2 ) {
            boardRows--;
        }
        
        // Set the number of images to choose from
        // We need 2 of each, so we halve the total tiles
        maxTiles = (boardRows * boardColumns) / 2;

        
        // Set up the padding between the tiles
        padWidth = 10;
        padHeight = 10;
        
        // We set the desired tile size
        float tileWidth = ((boardWidth -
                            (boardColumns * padWidth))
                           / boardColumns) - padWidth;
        float tileHeight = ((boardHeight -
                             (boardRows * padHeight))
                            / boardRows) - padHeight;

        // We force the tiles to be square
        if (tileWidth > tileHeight) {
            tileWidth = tileHeight;
        } else {
            tileHeight = tileWidth;
        }
        
        // Store the tileSize so we can use it later
        tileSize = CGSizeMake(tileWidth, tileHeight);

        // Set the offset from the edge
        boardOffsetX = (boardWidth - ((tileSize.width +
                        padWidth) * boardColumns)) / 2;
        boardOffsetY = (boardHeight - ((tileSize.height+
                        padHeight) * boardRows)) / 2;
        
        // Set the score to zero
        playerScore = 0;
        
        // Initialize the arrays
        tilesAvailable = [[NSMutableArray alloc]
                          initWithCapacity:maxTiles];
        tilesInPlay = [[NSMutableArray alloc]
                       initWithCapacity:maxTiles];
        tilesSelected = [[NSMutableArray alloc]
                         initWithCapacity:2];
        
        // Populate the tilesAvailable array
        [self acquireMemoryTiles];
        
        // Generate the actual playfield on-screen
        [self generateTileGrid];

        // Calculate the number of lives left
        [self calculateLivesRemaining];
        
        // We create the score and lives display here
        [self generateScoreAndLivesDisplay];
    }
	return self;
}


- (void) dealloc
{
    // Release the arrays
    [tilesAvailable release];
    [tilesInPlay release];
    [tilesSelected release];
    
	[super dealloc];
}

-(void) preloadEffects {
    // Preload all of our sound effects
    [[SimpleAudioEngine sharedEngine]
                        preloadEffect:SND_TILE_FLIP];
    [[SimpleAudioEngine sharedEngine]
                        preloadEffect:SND_TILE_SCORE];
    [[SimpleAudioEngine sharedEngine]
                        preloadEffect:SND_TILE_WRONG];
    [[SimpleAudioEngine sharedEngine]
                        preloadEffect:SND_SCORE];
}

#pragma mark Tile Loading And Selection
-(void) acquireMemoryTiles {
    // This method will create and load the MemoryTiles
    // into the tilesAvailable array
    
    // We assume the tiles all use standard names
    for (int cnt = 1; cnt <= maxTiles; cnt++) {
        // Load the tile into the array
        
        // We loop so we add each tile in the array twice
        // This gives us a matched pair of each tile
        for (NSInteger tileNo = 1; tileNo <= 2; tileNo++) {
            // Generate the tile image name
            NSString *imageName = [NSString
                    stringWithFormat:@"tile%i.png", cnt];
            
            //Create a new MemoryTile with this image
            MTMemoryTile *newTile = [MTMemoryTile
                    spriteWithSpriteFrameName:imageName];

            // We capture the image name for the tile face
            [newTile setFaceSpriteName:imageName]; 
            
            // We want the tiles to start face down
            [newTile showBack];
            
            // Add the MemoryTile to the array
            [tilesAvailable addObject:newTile];
        }
    }
}

-(void) generateTileGrid {
    // This method takes the tilesAvailable array,
    // and deals the tiles out to the board randomly
    // Tiles used will be moved to the tilesInPlay array
    
    // Loop through all the positions on the board
    for (NSInteger newRow = 1; newRow <= boardRows; newRow++) {
        for (NSInteger newCol = 1; newCol <= boardColumns; newCol++) {
            
            // We randomize each tile slot
            NSInteger rndPick = (NSInteger)arc4random() %
                                ([tilesAvailable count]);

            // Grab the MemoryTile from the array
            MTMemoryTile *newTile = [tilesAvailable
                                objectAtIndex:rndPick];

            // Let the tile "know" where it is
            [newTile setTileRow:newRow];
            [newTile setTileColumn:newCol];
            
            // Scale the tile to size
            float tileScaleX = tileSize.width /
                            newTile.contentSize.width;

            // We scale by X only (tiles are square)
            [newTile setScale:tileScaleX];

            // Set the positioning for the tile
            [newTile setPosition:[self tilePosforRow:newRow
                                        andColumn:newCol]];
            
            // Add the tile as a child of our batch node
            [self addChild:newTile];
            
            // Since we don't want to re-use this tile,
            // we remove it from the array
            [tilesAvailable removeObjectAtIndex:rndPick];
            
            // We retain the MemoryTile for later access
            [tilesInPlay addObject:newTile];
        }
    }    
}

#pragma mark Tile Matching Routines
-(void) checkForMatch {
    // Get the MemoryTiles for this comparison
    MTMemoryTile *tileA = [tilesSelected objectAtIndex:0];
    MTMemoryTile *tileB = [tilesSelected objectAtIndex:1];
    
    // See if the two tiles matched
    if ([tileA.faceSpriteName
            isEqualToString:tileB.faceSpriteName]) {
        // We start the scoring, lives, and animations
        [self scoreThisMemoryTile:tileA];
        [self scoreThisMemoryTile:tileB];
        [self animateScoreDisplay];
        [self calculateLivesRemaining];
        [self updateLivesDisplayQuiet];
        [self checkForGameOver];
        
    } else {
        // No match, flip the tiles back
        [tileA flipTile];
        [tileB flipTile];
        
        // Take off a life and update the display
        livesRemaining--;
        [self animateLivesDisplay];
    }

    // Remove the tiles from tilesSelected
    [tilesSelected removeAllObjects];
}

-(void) scoreThisMemoryTile:(MTMemoryTile*)aTile {
    // We set a baseline speed for the tile movement
    float tileVelocity = 600.0;
    
    // We calculate the time needed to move the tile
    CGPoint moveDifference = ccpSub([self scorePosition],
                                    aTile.position);
    float moveDuration = ccpLength(moveDifference) /
                                    tileVelocity;

    // Define the movement actions
    CCMoveTo *move = [CCMoveTo actionWithDuration:
                moveDuration position:[self scorePosition]];
    CCScaleTo *scale = [CCScaleTo actionWithDuration:0.5
                                            scale:0.001];
    CCDelayTime *delay = [CCDelayTime
                          actionWithDuration:0.5];
    CCCallFuncND *remove = [CCCallFuncND
                    actionWithTarget:self
                    selector:@selector(removeMemoryTile:)
                    data:aTile];

    // Run the actions
    [aTile runAction:[CCSequence actions:move, scale,
                      delay, remove, nil]];
    
    // Play the sound effect
    [[SimpleAudioEngine sharedEngine]
                        playEffect:SND_TILE_SCORE];
    
    // Remove the tile from the tilesInPlay array
    [tilesInPlay removeObject:aTile];
    
    // Add 1 to the player's score
    playerScore++;
    
    // Recalculate the number of lives left
    [self calculateLivesRemaining];
}

-(void) removeMemoryTile:(MTMemoryTile*)thisTile {
    [thisTile removeFromParentAndCleanup:YES];
}

#pragma mark Lives and Scoring
-(void) generateScoreAndLivesDisplay {
    // Build the word "SCORE"
    CCLabelTTF *scoreTitle = [CCLabelTTF
        labelWithString:@"SCORE" fontName:@"Marker Felt"
                              fontSize:30];
    [scoreTitle setPosition:ccpAdd([self scorePosition],
                                   ccp(0,30))];
    [self addChild:scoreTitle];
    
    // Build the display for the score counter
    playerScoreDisplay = [CCLabelTTF labelWithString:
            [NSString stringWithFormat:@"%i", playerScore]
            fontName:@"Marker Felt" fontSize:40];
    [playerScoreDisplay setPosition:[self scorePosition]];
    [self addChild:playerScoreDisplay];
    
    // Build the word "LIVES"
    CCLabelTTF *livesTitle = [CCLabelTTF labelWithString:
            @"LIVES" fontName:@"Marker Felt" fontSize:30];
    [livesTitle setPosition:ccpAdd([self livesPosition],
                                   ccp(0,30))];
    [livesTitle setColor:ccBLUE];
    [self addChild:livesTitle];
    
    // Built the display for the lives counter
    livesRemainingDisplay = [CCLabelTTF labelWithString:
            [NSString stringWithFormat:@"%i", livesRemaining]
            fontName:@"Marker Felt" fontSize:40];
    [livesRemainingDisplay setPosition:[self livesPosition]];
    [self resetLivesColor];
    [self addChild:livesRemainingDisplay];
}

-(void) animateScoreDisplay {
    // We delay for a second to allow the tiles to get
    // to the scoring position before we animate
    CCDelayTime *firstDelay = [CCDelayTime
                actionWithDuration:1.0];
    CCScaleTo *scaleUp = [CCScaleTo
                actionWithDuration:0.2 scale:2.0];
    CCCallFunc *updateScoreDisplay = [CCCallFunc
                actionWithTarget:self
                selector:@selector(updateScoreDisplay)];
    CCDelayTime *secondDelay = [CCDelayTime
                actionWithDuration:0.2];
    CCScaleTo *scaleDown = [CCScaleTo
                actionWithDuration:0.2 scale:1.0];
    
    [playerScoreDisplay runAction:[CCSequence actions:
                firstDelay, scaleUp, updateScoreDisplay,
                secondDelay, scaleDown, nil]];
}

-(void) updateScoreDisplay {
    // Change the score display to the new value
    [playerScoreDisplay setString:
     [NSString stringWithFormat:@"%i", playerScore]];
    
    // Play the "score" sound
    [[SimpleAudioEngine sharedEngine]
                            playEffect:SND_SCORE];
}

-(void) animateLivesDisplay {
    // We delay for a second to allow the tiles to flip back
    CCScaleTo *scaleUp = [CCScaleTo
            actionWithDuration:0.2 scale:2.0];
    CCCallFunc *updateLivesDisplay = [CCCallFunc
            actionWithTarget:self
            selector:@selector(updateLivesDisplay)];
    CCCallFunc *resetLivesColor = [CCCallFunc
            actionWithTarget:self
            selector:@selector(resetLivesColor)];
    CCDelayTime *delay = [CCDelayTime
            actionWithDuration:0.2];
    CCScaleTo *scaleDown = [CCScaleTo
            actionWithDuration:0.2 scale:1.0];
    [livesRemainingDisplay runAction:[CCSequence actions:
            scaleUp, updateLivesDisplay, delay, scaleDown,
            resetLivesColor, nil]];
}

-(void) updateLivesDisplayQuiet {
    // Change the lives display without the fanfare
    [livesRemainingDisplay setString:[NSString
            stringWithFormat:@"%i", livesRemaining]];
}

-(void) updateLivesDisplay {
    // Change the lives display to the new value
    [livesRemainingDisplay setString:[NSString
            stringWithFormat:@"%i", livesRemaining]];
    
    // Change the lives display to red
    [livesRemainingDisplay setColor:ccRED];

    // Play the "wrong" sound
    [[SimpleAudioEngine sharedEngine]
                        playEffect:SND_TILE_WRONG];
    
    [self checkForGameOver];
}

-(void) calculateLivesRemaining {
    // Lives equal half of the tiles on the board
    livesRemaining = [tilesInPlay count] / 2;
}

-(void) resetLivesColor {
    // Change the Lives counter back to blue
    [livesRemainingDisplay setColor:ccBLUE];
}

-(void) checkForGameOver {
    NSString *finalText;
    // Player wins
    if ([tilesInPlay count] == 0) {
        finalText = @"You Win!";
    // Player loses
    } else if (livesRemaining <= 0) {
        finalText = @"You Lose!";
    } else {
        // No game over conditions met
        return;
    }
    
    // Set the game over flag
    isGameOver = YES;
    
    // Display the appropriate game over message
    CCLabelTTF *gameOver = [CCLabelTTF
                    labelWithString:finalText
                    fontName:@"Marker Felt" fontSize:60];
    [gameOver setPosition:ccp(size.width/2,size.height/2)];
    [self addChild:gameOver z:50];
}

#pragma mark Object Positioning
-(CGPoint) tilePosforRow:(NSInteger)rowNum
               andColumn:(NSInteger)colNum {
    // Generate the coordinates for each tile
    float newX = boardOffsetX +
            (tileSize.width + padWidth) * (colNum - .5);
    float newY = boardOffsetY +
            (tileSize.height + padHeight) * (rowNum - .5);

    return ccp(newX, newY);
}

-(CGPoint) scorePosition {
    return ccp(size.width - 10 - tileSize.width/2,
               (size.height/4) * 3);
}

-(CGPoint) livesPosition {
    return ccp(size.width - 10 - tileSize.width/2,
               size.height/4);
}


#pragma mark Touch Handlers
-(void) ccTouchesEnded:(NSSet *)touches
             withEvent:(UIEvent *)event {
    
    // If game over, go back to the main menu on any touch
    if (isGameOver) {
        [[CCDirector sharedDirector]
                    replaceScene:[MTMenuScene node]];
    }
    
    UITouch *touch = [touches anyObject];
	
    CGPoint location = [touch locationInView: [touch view]];
    CGPoint convLoc = [[CCDirector sharedDirector]
                            convertToGL:location];
    
    // If the back button was pressed, we exit
    if (CGRectContainsPoint([backButton boundingBox],
                            convLoc)) {
        [[CCDirector sharedDirector]
                replaceScene:[MTMenuScene node]];
    }
    
    // If we have 2 tiles face up, do not respond
    if ([tilesSelected count] == 2) {
        return;
    } else {
        // Iterate through tilesInPlay to see which tile
        // was touched
        for (MTMemoryTile *aTile in tilesInPlay) {
            if ([aTile containsTouchLocation:convLoc] &&
                [aTile isFaceUp] == NO) {
                // Flip the tile
                [aTile flipTile];
                
                // Hold the tile in a buffer array
                [tilesSelected addObject:aTile];
                
                // Call the score/fail check,
                // if it is the second tile
                if ([tilesSelected count] == 2) {
                    // We delay so player can see tiles
                    [self scheduleOnce:@selector(checkForMatch)
                                 delay:1.0];
                    break;
                }
                
            }
        }
    }
}

@end
