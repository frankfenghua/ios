//
//  MAPlayfieldLayer.m
//  ch2-match3
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "MAPlayfieldLayer.h"

#define SND_SWOOSH @"swoosh.caf"
#define SND_DING @"ding.caf"

@implementation MAPlayfieldLayer

-(id) init {
	
    if (self == [super init]) {
        
        self.isTouchEnabled = YES;
        
        size = [[CCDirector sharedDirector] winSize];
        
        // Add our background image
        CCSprite *bg = [CCSprite spriteWithFile:
                        @"match3bg.png"];
        [bg setPosition:ccp(size.width/2,size.height/2)];
        [self addChild:bg z:0];
        
        // Load the spritesheet
        [[CCSpriteFrameCache sharedSpriteFrameCache]
         addSpriteFramesWithFile:@"match3sheet.plist"];
        matchsheet = [CCSpriteBatchNode batchNodeWithFile:
                      @"match3sheet.png" capacity:54];
        
        // Add the batch node to the layer
        [self addChild:matchsheet z:1];
        
        // Add the back Button to the UI, bottom left
        backButton = [CCSprite spriteWithSpriteFrameName:
                      @"backbutton.png"];
        [backButton setAnchorPoint:ccp(0,0)];
        [backButton setScale:0.7];
        [backButton setPosition:ccp(10, 10)];
        [matchsheet addChild:backButton];

        // Initialize the sizing of the board
        boardRows = 6;
        boardColumns = 7;
        boardOffsetWidth = 70;
        boardOffsetHeight = 0;
        padWidth = 4;
        padHeight = 4;
        gemSize = CGSizeMake(45,45);

        // Total number of unique gems in the game
        totalGemsAvailable = 7;

        // Initialize the arrays
        gemsInPlay = [[NSMutableArray alloc] init];
        gemMatches = [[NSMutableArray alloc] init];
        gemsTouched = [[NSMutableArray alloc] init];
        
        // Set the score to zero
        playerScore = 0;
        isGameOver = NO;

        // Preload the sound effects
        [self preloadEffects];
        
        // Add the score display to the screen
        [self generateScoreDisplay];
        
        // Add the timer display to the screen
        [self generateTimerDisplay];
        startingTimerValue = 60; // 1 minute
        currentTimerValue = startingTimerValue;
        
        [self generatePlayfield];
        
        //[self generateTestingPlayfield];  /// FOR DEBUGGING ONLY
        //[self drawGemMap:gemsInPlay];  /// FOR DEBUGGING ONLY
        
        [self checkMovesRemaining];
        
        [self scheduleUpdate];
    }
    return self;
}

-(void) dealloc {
    
    self.isTouchEnabled = NO;
    
    [gemsInPlay removeAllObjects];
    [gemsInPlay release];
    gemsInPlay = nil;
    
    [gemMatches removeAllObjects];
    [gemMatches release];
    gemMatches = nil;

    [gemsTouched removeAllObjects];
    [gemsTouched release];
    gemsTouched = nil;

    [super dealloc];
}

-(void) update:(ccTime)dt {
    
    gemsMoving = NO;
    
    // See if we have any gems currently moving
    for (MAGem *aGem in gemsInPlay) {
        if (aGem.gemState == kGemMoving) {
            gemsMoving = YES;
            break;
        }
    }
    
    // If we flagged that we need to check the board
    if (checkMatches) {
        [self checkMove];
        [self checkMovesRemaining];
        checkMatches = NO;
    }
    
    // Too few gems left.  Let's fill it up.
    // This will avoid any holes if our smartFill left
    // gaps, which is common on 4 and 5 gem matches.
    if ([gemsInPlay count] < boardRows * boardColumns &&
        gemsMoving == NO) {
        [self addGemsToFillBoard];
    }
    
    // Update the timer value & display
    currentTimerValue = currentTimerValue - dt;
    [timerDisplay setPercentage:(currentTimerValue /
                            startingTimerValue) * 100];
    
    // Game Over / Time's Up
    if (currentTimerValue <= 0) {
        [self unscheduleUpdate];
        isGameOver = YES;
        [self gameOver];
    }
}

#pragma mark Sound Effects
-(void) preloadEffects {
    [[SimpleAudioEngine sharedEngine]
                            preloadEffect:SND_SWOOSH];
    [[SimpleAudioEngine sharedEngine]
                            preloadEffect:SND_DING];
}

-(void) playSwoosh {
    [[SimpleAudioEngine sharedEngine]
                            playEffect:SND_SWOOSH
                            pitch:1.0 pan:0 gain:0.25];
}

-(void) playDing {
   [[SimpleAudioEngine sharedEngine] playEffect:SND_DING];
}

#pragma mark Generate Gem Grid
-(void) generatePlayfield {
    // Randomly select gems and place on the board
    // Iterate through all rows and columns
    for (int row = 1; row <= boardRows; row++) {
        for (int col = 1; col <= boardColumns; col++) {
            // Generate a gem for this slot
            [self generateGemForRow:row andColumn:col
                             ofType:kGemAnyType];
        }
    }
    
    // We check for matches now, and remove any gems 
    // from starting in the scoring position
    [self fixStartingMatches];

    // Add the gems to the layer
    for (MAGem *aGem in gemsInPlay) {
        [aGem setGemState:kGemIdle];
        [matchsheet addChild:aGem];
    }
}


-(void) fixStartingMatches {
    // This method checks for any possible matches
    // and will remove those gems. After fixing the gems,
    // we call this method again (from itself) until we
    // have a clean result
    [self checkForMatchesOfType:kGemNew];
    
    if ([gemMatches count] > 0) {
        
        // get the first matching gem
        MAGem *aGem = [gemMatches objectAtIndex:0];

        // Build a replacement gem
        [self generateGemForRow:[aGem rowNum] andColumn:
                    [aGem colNum] ofType:kGemAnyType];
            
        // Destroy the original gem
        [gemsInPlay removeObject:aGem];
        [gemMatches removeObject:aGem];
            
        // We recurse so we can see if the board is clean
        // When we have no gemMatches, we stop recursion
        [self fixStartingMatches];
    }
}

#pragma mark Generate Individual Gems
-(MAGem*) generateGemForRow:(NSInteger)rowNum
    andColumn:(NSInteger)colNum ofType:(GemType)newType {

    GemType gemNum;
    
    if (newType == kGemAnyType) {
        // If we passed a kGemAnyType, randomize the gem
        gemNum = (arc4random() % totalGemsAvailable) + 1;
    } else {
        // If we passed another value, use that gem type
        gemNum = newType;
    }

    // Generate the sprite name
    NSString *spritename = [NSString stringWithFormat:
                            @"gem%i.png", gemNum];

    // Build the MAGem, which is just an enhanced CCSprite
    MAGem *thisGem = [MAGem
                    spriteWithSpriteFrameName:spritename];
    
    // Set the gem's vars
    [thisGem setRowNum:rowNum];
    [thisGem setColNum:colNum];
    [thisGem setGemType:(GemType)gemNum];
    [thisGem setGemState:kGemNew];
    [thisGem setGameLayer:self];
    
    // Set the position for this gem
    [thisGem setPosition:[self positionForRow:rowNum
                                    andColumn:colNum]];
    
    // Add the gem to the array
    [gemsInPlay addObject:thisGem];
    
    // We return the newly created gem, which is already
    // added to the gemsInPlay array
    // It has NOT been added to the layer yet.
    return thisGem;
}

-(void) addGemForRow:(NSInteger)rowNum
           andColumn:(NSInteger)colNum
              ofType:(GemType)newType {

    // Add a replacement gem
    MAGem *thisGem = [self generateGemForRow:rowNum
                    andColumn:colNum ofType:newType];
    
    // We reset the gem above the screen
    [thisGem setPosition:ccpAdd(thisGem.position,
                                ccp(0,size.height))];

    // Add the gem to the scene
    [self addChild:thisGem];
    
    // Drop it to the correct position
    [self moveToNewSlotForGem:thisGem];
}

#pragma mark Gem Manipulation
-(void)swapGem:(MAGem*)aGem withGem:(MAGem*)bGem {
    NSInteger tempRowNumA;
    NSInteger tempColNumA;
    
    // Stop the highlight
    [aGem stopHighlightGem];
    [bGem stopHighlightGem];
    
    // Grab the temp location of aGem
    tempRowNumA = [aGem rowNum];
    tempColNumA = [aGem colNum];

    // Set the aGem to the values from bGem
    [aGem setRowNum:[bGem rowNum]];
    [aGem setColNum:[bGem colNum]];
    
    // Set the bGem to the values from the aGem temp vars
    [bGem setRowNum:tempRowNumA];
    [bGem setColNum:tempColNumA];
    
    // Move the gems
    [self moveToNewSlotForGem:aGem];
    [self moveToNewSlotForGem:bGem];
}

-(void) moveToNewSlotForGem:(MAGem*)aGem {
    // Set the gem's state to moving
    [aGem setGemState:kGemMoving];

    // Move the gem, play sound, let it rest
    CCMoveTo *moveIt = [CCMoveTo
            actionWithDuration:0.2
            position:[self positionForRow:[aGem rowNum]
                                andColumn:[aGem colNum]]];
    CCCallFunc *playSound = [CCCallFunc
            actionWithTarget:self
                    selector:@selector(playSwoosh)];
    CCCallFuncND *gemAtRest = [CCCallFuncND
            actionWithTarget:self
            selector:@selector(gemIsAtRest:) data:aGem];
    [aGem runAction:[CCSequence actions:moveIt,
                     playSound, gemAtRest, nil]];
}

-(void) gemIsAtRest:(MAGem*)aGem {
    // Reset the gem's state to Idle
    [aGem setGemState:kGemIdle];
    
    // Identify that we need to check for matches
    checkMatches = YES;
}

-(void) resetGemPosition:(MAGem*)aGem {
    // Quickly snap the gem back to its desired position
    // Used after the gem stops animating
    [aGem setPosition:[self positionForRow:[aGem rowNum]
                            andColumn:[aGem colNum]]];
}

-(void) animateGemRemoval:(MAGem*)aGem {
    // We swap the image to "boom", and animate it out
    CCCallFuncND *changeImage = [CCCallFuncND
            actionWithTarget:self
            selector:@selector(changeGemFace:) data:aGem];
    CCCallFunc *updateScore = [CCCallFunc
            actionWithTarget:self
            selector:@selector(incrementScore)];
    CCCallFunc *addTime = [CCCallFunc
            actionWithTarget:self
            selector:@selector(addTimeToTimer)];
    CCMoveBy *moveUp = [CCMoveBy actionWithDuration:0.3
            position:ccp(0,5)];
    CCFadeOut *fade = [CCFadeOut actionWithDuration:0.2];
    CCCallFuncND *removeGem = [CCCallFuncND
            actionWithTarget:self
            selector:@selector(removeGem:) data:aGem];
    
    [aGem runAction:[CCSequence actions:changeImage,
            updateScore, addTime, moveUp, fade,
            removeGem, nil]];
}

-(void) changeGemFace:(MAGem*)aGem {
    // Swap the gem texture to the "boom" image
    [aGem setDisplayFrame:[[CCSpriteFrameCache
                        sharedSpriteFrameCache]
                        spriteFrameByName:@"boom.png"]];
}

-(void) removeGem:(MAGem*)aGem {
    // Clean up after ourselves and get rid of this gem
    [gemsInPlay removeObject:aGem];
    [aGem setGemState:kGemScoring];
    [self fillHolesFromGem:aGem];
    [aGem removeFromParentAndCleanup:YES];
    checkMatches = YES;
}

#pragma mark Scoring 

-(void) generateScoreDisplay {
    // Create the word "score"
    CCLabelTTF *scoreTitleLbl = [CCLabelTTF
        labelWithString:@"SCORE" fontName:@"Marker Felt"
                                 fontSize:20];
    [scoreTitleLbl setPosition:ccpAdd([self scorePosition],
                                      ccp(0,20))];
    [self addChild:scoreTitleLbl z:2];
    
    // Generate the display for the actual numeric score
    scoreLabel = [CCLabelTTF labelWithString:[NSString
                stringWithFormat:@"%i", playerScore]
                fontName:@"Marker Felt" fontSize:18];
    [scoreLabel setPosition:[self scorePosition]];
    [self addChild:scoreLabel z:3];
}

-(void) incrementScore {
    // Increment the score and update the display
    playerScore++;
    [self updateScore];
}

-(void) updateScore {
    // Update the score label with the new score value
    [scoreLabel setString:[NSString stringWithFormat:@"%i",
                           playerScore]];
}


#pragma mark Timer & Game Over
-(void) generateTimerDisplay {
    
    // Add a frame for the timer
    CCSprite *timerFrame = [CCSprite
                    spriteWithFile:@"timer.png"];
    [timerFrame setPosition:[self timerPosition]];
    [self addChild:timerFrame z:8];

    // Create a sprite for the timer
    CCSprite *timerSprite = [CCSprite
                    spriteWithFile:@"timer_back.png"];
    
    // Add the timer itself
    timerDisplay = [CCProgressTimer
                    progressWithSprite:timerSprite];
    [timerDisplay setPosition:[self timerPosition]];
    [timerDisplay setType:kCCProgressTimerTypeRadial];
    [self addChild:timerDisplay z:4];
    
    [timerDisplay setPercentage:100];
}

-(void) addTimeToTimer {
    // Add 1 second to the clock
    currentTimerValue = currentTimerValue + 1;
    
    // If we are full, take it back to maximum
    if (currentTimerValue > startingTimerValue) {
        currentTimerValue = startingTimerValue;
    }
}

-(void) gameOver {
    // Add a basic Game Over text
    CCLabelTTF *gameOverLabel = [CCLabelTTF
                            labelWithString:@"Game Over"
                            fontName:@"Marker Felt"
                            fontSize:60];
    [gameOverLabel setPosition:ccp(size.width/2,
                                   size.height/2)];
    [self addChild:gameOverLabel z:50];

    // Add a second Game Over text, as a simple drop shadow
    CCLabelTTF *gameOverLabelShadow = [CCLabelTTF
                labelWithString:@"Game Over"
                fontName:@"Marker Felt" fontSize:60];
    [gameOverLabelShadow setPosition:ccp(size.width/2 - 4,
                                    size.height/2 - 4)];
    [gameOverLabelShadow setColor:ccBLACK];
    [self addChild:gameOverLabelShadow z:49];
}

#pragma mark Check After Move Is Made
-(void) checkMove {
    // A move was made, so check for potential matches
    [self checkForMatchesOfType:kGemIdle];

    // Did we have any matches?
    if ([gemMatches count] > 0) {
        // Iterate through all matched gems
        for (MAGem *aGem in gemMatches) {
            // If the gem is not already in scoring state
            if (aGem.gemState != kGemScoring) {
                // Trigger the scoring & removal of gem
                [self animateGemRemoval:aGem]; 
            }
        }
        // All matches processed.  Clear the array.
        [gemMatches removeAllObjects];
    // If we have any selected/touched gems, we must
    // have made an incorrect move
    } else if ([gemsTouched count] > 0) {
        // If there was only one gem, grab it
        MAGem *aGem = [gemsTouched objectAtIndex:0];
        
        // If we had 2 gems in the touched array
        if ([gemsTouched count] == 2) {
            // Grab the second gem
            MAGem *bGem = [gemsTouched objectAtIndex:1];
            // Swap them back to their original slots
            [self swapGem:aGem withGem:bGem];
        } else {
            // If we only had 1 gem, stop highlighting it
            [aGem stopHighlightGem];
        }
    }
    // Touches were processed.  Clear the touched array.
    [gemsTouched removeAllObjects];
}

#pragma mark Gem Dropping
-(void) fillHolesFromGem:(MAGem*)aGem {
    // aGem passed is one that is being scored.
    // We know we will need to fill in the holes, so 
    // this method takes care of that.
    
    for (MAGem *thisGem in gemsInPlay) {
        // If thisGem is in the same column and ABOVE
        // the current matching gem, we reset the
        // position down, so we can fill the hole
        if (aGem.colNum == thisGem.colNum && 
            aGem.rowNum < thisGem.rowNum) {
            // Set thisGem to drop down one row
            [thisGem setRowNum:thisGem.rowNum - 1];            
            [self moveToNewSlotForGem:thisGem];
        }
    }
    
    // Call the smart fill method.
    // If we do NOT want artifical randomness, comment
    // out this one call to smartFill, and everything 
    // will be back to completely random gems.
    [self smartFill];
}

-(void) addGemsToFillBoard {
    // Loop through all positions, see if we have a gem
    for (int i = 1; i <= boardRows; i++) {
        for (int j = 1; j <= boardColumns; j++) {
            
            BOOL missing = YES;

            // Look for a missing gem in each slot
            for (MAGem *aGem in gemsInPlay) {
                if (aGem.rowNum == i && aGem.colNum == j
                    && aGem.gemState != kGemScoring) {
                    // Found a gem, not missing
                    missing = NO;
                }
            }
            
            // We didn't find anything in this slot.
            if (missing) {
                [self addGemForRow:i andColumn:j
                            ofType:kGemAnyType];
            }
        }
    }
    // We possibly changed the board, trigger match check
    checkMatches = YES;
}

#pragma mark Match Checking (actual board)
-(void) checkForMatchesOfType:(GemType)desiredGemState {
    // This method checks for any 3 in a row matches,
    // and stores the resulting "scoring matches" in
    // the gemMatches array
    
    // We use the desiredGemState parameter to check for
    // kGemIdle or kGemNew, depending on whether the
    // game is in play or if it is initial board creation
    
    // Let's look for horizontal matches    
    for (MAGem *aGem in gemsInPlay) {
        // Let's grab the first gem
        if (aGem.gemState == desiredGemState) {
            // If it is the desired state, let's look
            // for a matching neighbor gem
            for (MAGem *bGem in gemsInPlay) {
                // If the gem is the same type and state,
                // in the same row, and to the right
                if ([aGem isGemSameAs:bGem] &&
                        [aGem isGemInSameRow:bGem] &&
                    aGem.colNum == bGem.colNum - 1 &&
                    bGem.gemState == desiredGemState) {
                    // Now we loop through again,
                    // looking for a 3rd in a row
                    for (MAGem *cGem in gemsInPlay) {
                        // If this is the 3rd gem in a row
                        // in the desired state
                        if (aGem.colNum == cGem.colNum - 2 &&
                            cGem.gemState == desiredGemState) {
                            // Is the gem the same type
                            // and in the same row?
                            if ([aGem isGemSameAs:cGem] &&
                                [aGem isGemInSameRow:cGem]) {
                                // Add gems to match array
                                [self addGemToMatch:aGem];
                                [self addGemToMatch:bGem];
                                [self addGemToMatch:cGem];
                                break;
                            }
                        }
                    }
                } 
            }
        }
        // Let's look for vertical matches 
        for (MAGem *aGem in gemsInPlay) {
            // Let's grab the first gem
            if (aGem.gemState == desiredGemState) {
                // If it is the desired state, let's look for a matching neighbor gem
                for (MAGem *bGem in gemsInPlay) {
                    // If the gem is the same type and state, in the same column, and above
                    if ([aGem isGemSameAs:bGem] &&
                        [aGem isGemInSameColumn:bGem] &&
                        aGem.rowNum == bGem.rowNum - 1 &&
                        bGem.gemState == desiredGemState) {
                        // Now we loop through again, looking for a 3rd in the column
                        for (MAGem *cGem in gemsInPlay) {
                            // If this is the 3rd gem in a row in the desired state
                            if (bGem.rowNum == cGem.rowNum - 1 &&
                                cGem.gemState == desiredGemState) {
                                // Is the gem the same type and in the same column?
                                if ([bGem isGemSameAs:cGem] &&
                                    [bGem isGemInSameColumn:cGem]) {
                                    // Add gems to match array
                                    [self addGemToMatch:aGem];
                                    [self addGemToMatch:bGem];
                                    [self addGemToMatch:cGem];
                                    break;
                                } 
                            }
                        }
                    }
                } 
            }
        }
    }
}

-(void) addGemToMatch:(MAGem*)thisGem {
    // Only adds it to the array if it isn't already there
    if ([gemMatches indexOfObject:thisGem] == NSNotFound) {
        [gemMatches addObject:thisGem];
    }
}



#pragma mark Match Checking (predictive)
-(void) checkMovesRemaining {
    // This method is code-heavy and a little difficult to follow in places.
    // It converts the gemsInPlay array to a 2 dimensional C-style array.
    // This allows us to easily check neighbor gems.
    
    // We then iterate through every position on the board, starting with
    // row 1, column 1.  For each position, we test swapping the current gem 
    // with the neighbor to the right and the neighbor above it.  
    // We then check for potential matches with this new (theoretical) board.
    // We record how many matches we can make if we move that gem, and then we 
    // do the same for the next gem.  Note: we never actually change the board
    // in this method.  We only experiment with the "map" array, which is no
    // longer in scope when we leave this method.

    NSInteger matchesFound = 0;
    NSInteger gemsInAction = 0;
    
    // Create a temporary C-style array
    NSInteger map[12][12];
    
    // Make sure it is cleared
    for (int i = 1; i< 12; i++) {
        for (int j = 1; j < 12; j++) {
            map[i][j] = 0;
        }
    }
    
    // Load all gem types into it
    for (MAGem *aGem in gemsInPlay) {
        if (aGem.gemState != kGemIdle) {
            // If gem is moving or scoring, fill with zero
            map[aGem.rowNum][aGem.colNum] = 0;
            gemsInAction++;
        } else {            
            map[aGem.rowNum][aGem.colNum] = aGem.gemType;
        }
    }
    
    // Loop through all slots on the board
    for (int row = 1; row <= boardRows; row++) {
        for (int col = 1; col <= boardColumns; col++) {

            // Grid variables look like:
            //
            //        j
            //        h i
            //    k l e f g 
            //    m n a b c d
            //        o p
            //        q r
            
            // where "a" is the root gem we're testing
            // The swaps we test are a/b and a/e
            // So we need to identify all possible matches
            // that those swaps could cause
            GemType a = map[row][col];
            GemType b = map[row][col+1];
            GemType c = map[row][col+2];
            GemType d = map[row][col+3];
            GemType e = map[row+1][col];
            GemType f = map[row+1][col+1];
            GemType g = map[row+1][col+2];
            GemType h = map[row+2][col];
            GemType i = map[row+2][col+1];
            GemType j = map[row+3][col];
            GemType k = map[row+1][col-2];
            GemType l = map[row+1][col-1];
            GemType m = map[row][col-2];
            GemType n = map[row][col-1];
            GemType o = map[row-1][col];
            GemType p = map[row-1][col+1];
            GemType q = map[row-2][col];
            GemType r = map[row-2][col+1];
            
            // deform the board-swap of a and b, test
            GemType newA = b;
            GemType newB = a;
            
            matchesFound = matchesFound +
                [self findMatcheswithA:h andB:e
                            andC:newA andD:o andE:q];
            matchesFound = matchesFound + 
                [self findMatcheswithA:i andB:f
                            andC:newB andD:p andE:r];
            matchesFound = matchesFound +
                [self findMatcheswithA:m andB:n
                            andC:newA andD:0 andE:0];
            matchesFound = matchesFound +
                [self findMatcheswithA:newB andB:c
                            andC:d andD:0 andE:0];

            // Now we swap a and e, then test
            newA = e;
            GemType newE = a;
            
            matchesFound = matchesFound +
                [self findMatcheswithA:m andB:n
                            andC:newA andD:b andE:c];
            matchesFound = matchesFound +
                [self findMatcheswithA:k andB:l
                            andC:newE andD:f andE:g];
            matchesFound = matchesFound +
                [self findMatcheswithA:newA andB:o
                            andC:q andD:0 andE:0];
            matchesFound = matchesFound +
                [self findMatcheswithA:newE andB:h
                            andC:j andD:0 andE:0];
        }
    }

    // See if we have gems in motion on the board
    // Set the BOOL so other methods don't try to fix 
    // any "problems" with a moving board
    gemsMoving = (gemsInAction > 0);
    
    movesRemaining = matchesFound;
}

-(NSInteger) findMatcheswithA:(NSInteger)a
                         andB:(NSInteger)b
                         andC:(NSInteger)c
                         andD:(NSInteger)d
                         andE:(NSInteger)e {
    NSInteger matches = 0;
    
    // For each grouping of (up to) 5 gems, we check to see if we have a 5 match,
    // a 4 match, or a 3 match out of these 5.  It is impossible to have more than 5
    // in a row because anything longer would already have a 3 match made, and been
    // scored.
    // If there are zeroes, we do NOT want to count that as a match.
    
    if (a == b && b == c && c == d && d == e &&
                            a + b + c + d + e != 0) {
        // 5 match
        matches++;        
    } else if (a == b && b == c && c == d  &&
                            a + b + c + d != 0) {
        // 4 match (left)
        matches++;
    } else if (b == c && c == d && d == e &&
                            b + c + d + e != 0) {
        // 4 match (right)
        matches++;
    } else if (a == b && b == c && a + b + c != 0) {
        // 3 match (left)
        matches++;
    } else if (b == c && c == d && b + c + d != 0) {
        // 3 match (mid)
        matches++;
    } else if (c == d && d == e && c + d + e != 0) {
        // 3 match (right)
        matches++;
    }
    return matches;
}

-(void) smartFill {
    // This method controls all gem fillins during the game.
    
    // The structure is very similar to the checkMovesRemaining
    // method, except this is determining the best gems to fill 
    // in that will be able to be matched.

    // In case we were scheduled, unschedule it first
    [self unschedule:@selector(smartFill)];
    
    // If anything is moving, we don't want to fill yet
    if (gemsMoving) {
        // We reschedule so we retry when gems are not moving
        [self schedule:@selector(smartFill) interval:0.05];
        return;
    }
    
    // If we have plenty of matches, use a random fill
    if (movesRemaining >= 6) {
        [self addGemsToFillBoard];
        return;
    }
    
    // Create a temporary C-style array
    // We make it bigger than the playfield on purpose
    // This way we can evaluate past the edges
    NSInteger map[12][12];
    
    // Make sure it is cleared
    for (int i = 1; i < boardRows + 5; i++) {
        for (int j = 1; j < boardColumns + 5; j++) {
            if (i > boardRows || j > boardColumns) {
                // If row or column is bigger than board,
                // assign a -1 value
                map[i][j] = -1;
            } else {
                // If it is on the board, zero it
                map[i][j] = 0;
            }
        }
    }
    
    // Load all gem types into it
    for (MAGem *aGem in gemsInPlay) {
        // We don't want to include scoring gems
        if (aGem.gemState == kGemScoring) {
            map[aGem.rowNum][aGem.colNum] = 0;
        } else {
            // Assign the gemType to the array slot
            map[aGem.rowNum][aGem.colNum] = aGem.gemType;
        }
    }
    
    // Parse through the map, looking for zeroes
    for (int row = 1; row <= boardRows; row++) {
        for (int col = 1; col <= boardColumns; col++) {
            
            // We use "intelligent randomness" to fill 
            // holes when close to running out of matches
            
            // Grid variables look like:
            //        
            //        h
            //        e   g 
            //      n a b c 
            //      s o p t
            //    
            
            // where "a" is the root gem we're testing
            
            GemType a = map[row][col];
            GemType b = map[row][col+1];
            GemType c = map[row][col+2];
            GemType e = map[row+1][col];
            GemType g = map[row+1][col+2];
            GemType h = map[row+2][col];
            GemType n = map[row][col-1];
            GemType o = map[row-1][col];
            GemType p = map[row-1][col+1];
            GemType s = map[row-1][col-1];
            GemType t = map[row-1][col+2];

            // Vertical hole, 3 high
            if (a == 0 && e == 0 && h == 0) {
                if ((int)p >= 1) {
                    [self addGemForRow:row andColumn:col
                                ofType:p];
                    [self addGemForRow:row+1 andColumn:col
                                ofType:p];
                    [self addGemForRow:row+2 andColumn:col
                                ofType:kGemAnyType];
                    [self checkMovesRemaining];
                    [self smartFill];
                    return;
                }
                
                if ((int)s >= 1) {
                    [self addGemForRow:row andColumn:col
                                ofType:s];
                    [self addGemForRow:row+1 andColumn:col
                                ofType:s];
                    [self addGemForRow:row+2 andColumn:col
                                ofType:kGemAnyType];
                    [self checkMovesRemaining];
                    [self smartFill];
                    return;
                }
                
                if ((int)n >= 1) {
                    [self addGemForRow:row andColumn:col
                                ofType:kGemAnyType];
                    [self addGemForRow:row+1 andColumn:col
                                ofType:n];
                    [self addGemForRow:row+2 andColumn:col
                                ofType:n];
                    [self checkMovesRemaining];
                    [self smartFill];
                    return;
                }
                
                if ((int)b >= 1) {
                    [self addGemForRow:row andColumn:col
                                ofType:kGemAnyType];
                    [self addGemForRow:row+1 andColumn:col
                                ofType:b];
                    [self addGemForRow:row+2 andColumn:col
                                ofType:b];
                    [self checkMovesRemaining];
                    [self smartFill];
                    return;
                }
            }
            
            
            // Horizontal hole, 3 high
            if (a == 0 && b == 0 && c == 0) {
                if ((int)o >= 1) {
                    [self addGemForRow:row andColumn:col
                                ofType:kGemAnyType];
                    [self addGemForRow:row andColumn:col+1
                                ofType:o];
                    [self addGemForRow:row andColumn:col+2
                                ofType:o];
                    [self checkMovesRemaining];
                    [self smartFill];
                    return;
                }
                
                if ((int)t >= 1) {
                    [self addGemForRow:row andColumn:col
                                ofType:t];
                    [self addGemForRow:row andColumn:col+1
                                ofType:t];
                    [self addGemForRow:row andColumn:col+2
                                ofType:kGemAnyType];
                    [self checkMovesRemaining];
                    [self smartFill];
                    return;
                }
                
                if ((int)e >= 1) {
                    [self addGemForRow:row andColumn:col
                                ofType:kGemAnyType];
                    [self addGemForRow:row andColumn:col+1
                                ofType:e];
                    [self addGemForRow:row andColumn:col+2
                                ofType:e];
                    [self checkMovesRemaining];
                    [self smartFill];
                    return;
                }
                
                if ((int)g >= 1) {
                    [self addGemForRow:row andColumn:col
                                ofType:g];
                    [self addGemForRow:row andColumn:col+1
                                ofType:g];
                    [self addGemForRow:row andColumn:col+2
                                ofType:kGemAnyType];
                    [self checkMovesRemaining];
                    [self smartFill];
                    return;
                }
            }
        }
    }
}

#pragma mark Object Positioning
-(CGPoint) positionForRow:(NSInteger)rowNum andColumn:(NSInteger)colNum {
    
    float x = boardOffsetWidth + ((gemSize.width + padWidth) * colNum);
    float y = boardOffsetHeight + ((gemSize.height + padHeight) * rowNum);
    
    return ccp(x,y);
}

-(CGPoint) scorePosition {
    return ccp(50, size.height - 50);
}

-(CGPoint) timerPosition {
    return ccp(50, size.height/2);
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
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint location = [touch locationInView:[touch view]];
    CGPoint convLoc = [[CCDirector sharedDirector]
                       convertToGL:location];
    
    // If we reached game over, any touch returns to menu
    if (isGameOver) {
        [[CCDirector sharedDirector]
                replaceScene:[MAMenuScene scene]];
        return YES;
    }
    
    // If the back button was pressed, we exit
    if (CGRectContainsPoint([backButton boundingBox],
                            convLoc)) {
        [[CCDirector sharedDirector]
         replaceScene:[MAMenuScene node]];
        return YES;
    }
    
    // If we have only 0 or 1 gem in gemsTouched, track
    if ([gemsTouched count] < 2) {
        // Check each gem
        for (MAGem *aGem in gemsInPlay) {
            // If the gem was touched AND the gem is idle,
            // return YES to track the touch
            if ([aGem containsTouchLocation:convLoc] &&
                            aGem.gemState == kGemIdle) {
                return YES;
            }
        }
    }

    // If we failed to find any good touch, return
    return NO;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    // Swipes are handled here.
    [self touchHelper:touch withEvent:event];
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    // Taps are handled here.    
    [self touchHelper:touch withEvent:event];
}

-(void) touchHelper:(UITouch *)touch withEvent:(UIEvent *)event {
    // If we're already checking for a match, ignore
    if ([gemsTouched count] >= 2 || gemsMoving == YES) {
        return;
    }
    
    CGPoint location = [touch locationInView:[touch view]];
    CGPoint convLoc = [[CCDirector sharedDirector]
                       convertToGL:location];
    
    // Let's figure out which gem was touched (if any)
    for (MAGem *aGem in gemsInPlay) {
        if ([aGem containsTouchLocation:convLoc] &&
            aGem.gemState == kGemIdle) {
            // We can't add the same gem twice
            if ([gemsTouched containsObject:aGem] == NO) {
                // Add the gem to the array
                [self playDing];
                [gemsTouched addObject:aGem];
                [aGem highlightGem];
            }
        }
    }
    
    // We now have touched 2 gems.  Let's swap them.
    if ([gemsTouched count] >= 2) {
        MAGem *aGem = [gemsTouched objectAtIndex:0];
        MAGem *bGem = [gemsTouched objectAtIndex:1];
        
        // If the gems are adjacent, we can swap
        if ([aGem isGemBeside:bGem]) {
            [self swapGem:aGem withGem:bGem];
        } else {
            // They're not adjacent, so let's drop
            // the first gem
            [aGem stopHighlightGem];
            [gemsTouched removeObject:aGem];
        }
    }
}

#pragma mark Brute Force Debugging Tools
-(void) drawGemMap:(NSMutableArray*)sourceArray {
    // Brute force debugger, produces a grid of numbers in the output window
    NSInteger map[8][8];
    
    for (int i = 1; i< 8; i++) {
        for (int j = 1; j < 8; j++) {
            map[i][j] = 0;
        }
    }
    
    for (MAGem *aGem in sourceArray) {
        map[aGem.rowNum][aGem.colNum] = (NSInteger)aGem.gemType;
    }
    
    NSString *map1 = [NSString stringWithFormat:@"%i %i %i %i %i %i %i", map[1][1], map[1][2], map[1][3], map[1][4], map[1][5],
                      map[1][6], map[1][7]];
    
    NSString *map2 = [NSString stringWithFormat:@"%i %i %i %i %i %i %i", map[2][1], map[2][2], map[2][3], map[2][4], map[2][5],
                      map[2][6], map[2][7]];
    NSString *map3 = [NSString stringWithFormat:@"%i %i %i %i %i %i %i", map[3][1], map[3][2], map[3][3], map[3][4], map[3][5],
                      map[3][6], map[3][7]];
    
    NSString *map4 = [NSString stringWithFormat:@"%i %i %i %i %i %i %i", map[4][1], map[4][2], map[4][3], map[4][4], map[4][5],
                      map[4][6], map[4][7]];
    
    NSString *map5 = [NSString stringWithFormat:@"%i %i %i %i %i %i %i", map[5][1], map[5][2], map[5][3], map[5][4], map[5][5],
                      map[5][6], map[5][7]];
    
    NSString *map6 = [NSString stringWithFormat:@"%i %i %i %i %i %i %i", map[6][1], map[6][2], map[6][3], map[6][4], map[6][5],
                      map[6][6], map[6][7]];
    
    NSLog(@"%@", map6);
    NSLog(@"%@", map5);
    NSLog(@"%@", map4);
    NSLog(@"%@", map3);
    NSLog(@"%@", map2);
    NSLog(@"%@", map1);
    
}

-(void) generateTestingPlayfield {
    // This generates a testing playfield that looks like:
    //
    // 3322122
    // 6565241
    // 1127334
    // 7654721
    // 7651234
    // 1234567
    
    [self generateGemForRow:1 andColumn:1 ofType:1];
    [self generateGemForRow:1 andColumn:2 ofType:2];
    [self generateGemForRow:1 andColumn:3 ofType:3];
    [self generateGemForRow:1 andColumn:4 ofType:4];
    [self generateGemForRow:1 andColumn:5 ofType:5];
    [self generateGemForRow:1 andColumn:6 ofType:6];
    [self generateGemForRow:1 andColumn:7 ofType:7];
    
    [self generateGemForRow:2 andColumn:1 ofType:7];
    [self generateGemForRow:2 andColumn:2 ofType:6];
    [self generateGemForRow:2 andColumn:3 ofType:5];
    [self generateGemForRow:2 andColumn:4 ofType:1];
    [self generateGemForRow:2 andColumn:5 ofType:2];
    [self generateGemForRow:2 andColumn:6 ofType:3];
    [self generateGemForRow:2 andColumn:7 ofType:4];
    
    [self generateGemForRow:3 andColumn:1 ofType:7];
    [self generateGemForRow:3 andColumn:2 ofType:6];
    [self generateGemForRow:3 andColumn:3 ofType:5];
    [self generateGemForRow:3 andColumn:4 ofType:4];
    [self generateGemForRow:3 andColumn:5 ofType:7];
    [self generateGemForRow:3 andColumn:6 ofType:2];
    [self generateGemForRow:3 andColumn:7 ofType:1];
    
    [self generateGemForRow:4 andColumn:1 ofType:1];
    [self generateGemForRow:4 andColumn:2 ofType:1];
    [self generateGemForRow:4 andColumn:3 ofType:2];
    [self generateGemForRow:4 andColumn:4 ofType:7];
    [self generateGemForRow:4 andColumn:5 ofType:3];
    [self generateGemForRow:4 andColumn:6 ofType:3];
    [self generateGemForRow:4 andColumn:7 ofType:4];

    [self generateGemForRow:5 andColumn:1 ofType:6];
    [self generateGemForRow:5 andColumn:2 ofType:5];
    [self generateGemForRow:5 andColumn:3 ofType:6];
    [self generateGemForRow:5 andColumn:4 ofType:5];
    [self generateGemForRow:5 andColumn:5 ofType:2];
    [self generateGemForRow:5 andColumn:6 ofType:4];
    [self generateGemForRow:5 andColumn:7 ofType:1];
    
    [self generateGemForRow:6 andColumn:1 ofType:3];
    [self generateGemForRow:6 andColumn:2 ofType:3];
    [self generateGemForRow:6 andColumn:3 ofType:2];
    [self generateGemForRow:6 andColumn:4 ofType:2];
    [self generateGemForRow:6 andColumn:5 ofType:1];
    [self generateGemForRow:6 andColumn:6 ofType:2];
    [self generateGemForRow:6 andColumn:7 ofType:2];
        
    // Add the gems to the layer
    for (MAGem *aGem in gemsInPlay) {
        [aGem setGemState:kGemIdle];
        [matchsheet addChild:aGem];
    }
    
    //[self checkMovesRemaining];
    
    NSLog(@"test created %i movesRemaining", movesRemaining);
}


@end
