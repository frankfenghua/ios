//
//  MXPlayfieldLayer.m
//  ch3-moles
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "MXPlayfieldLayer.h"

@implementation MXPlayfieldLayer

@synthesize moleRaiseTime;
@synthesize moleDelayTime;
@synthesize moleDownTime;

-(id) init {
    if(self = [super init]) {
        
        self.isTouchEnabled = YES;
        
        size = [[CCDirector sharedDirector] winSize];
        
        // Load the spritesheet
        [[CCSpriteFrameCache sharedSpriteFrameCache]
            addSpriteFramesWithFile:@"molesheet.plist"];
        molesheet = [CCSpriteBatchNode
            batchNodeWithFile:@"molesheet.png"
            capacity:54];
        
        // Add the batch node to the layer
        [self addChild:molesheet z:1];
        
        // Add the back Button to the UI, bottom left
        backButton = [CCSprite
            spriteWithSpriteFrameName:@"backbutton.png"];
        [backButton setAnchorPoint:ccp(0,1)];
        [backButton setScale:0.7];
        [backButton setPosition:ccp(10, size.height-10)];
        [molesheet addChild:backButton z:100];
        
        // Build the animations in the cache
        [self buildAnimations];

        // Preload the sound effects
        [self preloadEffects];
        
        // Set up the array
        moleHillsInPlay = [[NSMutableArray alloc] init];
        
        // Add the background
        [self drawGround];
        
        // Add the molehills
        [self drawHills];
        
        // Various variable settings
        maxHillRows = 4;
        maxHillColumns = 3;
        maxHills = maxHillRows * maxHillColumns;
        maxMoles = 3;
        spawnRest = 0;
        isGameOver = NO;

        // Add the timer display to the screen
        [self generateTimerDisplay];
        startingTimerValue = 60; // 1 minute
        currentTimerValue = startingTimerValue;
        
        // Add the score display to the screen
        playerScore = 0;
        [self generateScoreDisplay];
        
        // Set up time factors to use raising the mole
        float tempTimeVal = 1.5 - (20 * 0.025);
        
        // Don't let it get unplayable
        if (tempTimeVal < 0.33f) { tempTimeVal = 0.33f; }
        
        [self setMoleRaiseTime:tempTimeVal];
        [self setMoleDelayTime:tempTimeVal-.25];
        [self setMoleDownTime:tempTimeVal];
    }
    
    return self;
}

-(void) dealloc {
    
    for (MXMoleHill *aHill in moleHillsInPlay) {
        
        [[aHill hillMole] destroyTouchDelegate];
        
        // Remove the "hook" from the mole to the hill
        [[aHill hillMole] setParentHill:nil];

        // Release the mole
        [[[aHill hillMole] moleSprite]
                        removeFromParentAndCleanup:YES];
        [[aHill hillMole] setMoleSprite:nil];
        
        // Remove the "hook' from the hill to the mole 
        [aHill setHillMole:nil];

        [[aHill moleHillTop]
                        removeFromParentAndCleanup:YES];
        [[aHill moleHillBottom]
                        removeFromParentAndCleanup:YES];

        [aHill setMoleHillTop:nil];
        [aHill setMoleHillBottom:nil];

        molesInPlay--;
	}

    [moleHillsInPlay removeAllObjects];
    [moleHillsInPlay release];
    moleHillsInPlay = nil;
    
    [molesheet stopAllActions];
    [molesheet removeAllChildrenWithCleanup:YES];
    
    [super dealloc];
}

-(void) onEnterTransitionDidFinish {
    [self scheduleUpdate];
}

#pragma mark Audio Setup
-(void) preloadEffects {
    [[SimpleAudioEngine sharedEngine]
                        preloadEffect:SND_BUTTON];
    [[SimpleAudioEngine sharedEngine]
                        preloadEffect:SND_MOLE_NORMAL];
    [[SimpleAudioEngine sharedEngine]
                        preloadEffect:SND_MOLE_SPECIAL];
}

#pragma mark Update Method
-(void)update:(ccTime)dt {
	
	for (MXMoleHill *aHill in moleHillsInPlay) {
        
		if (aHill.hillMole.moleState == kMoleHit) {
            [[aHill hillMole] setMoleState:kMoleMoving];
			[self scoreMole:[aHill hillMole]];
		}
	}
    
    if (molesInPlay < maxMoles && spawnRest > 10) {
        [self spawnMole:self];
        spawnRest = 0;
    } else {
        spawnRest++;
    }
    
    // Update the timer value & display
    currentTimerValue = currentTimerValue - dt;
    
    // Protection against overfilling the timer
    if (currentTimerValue > startingTimerValue) {
        currentTimerValue = startingTimerValue;
    }
    
    // Update the timer visual
    [timerDisplay setPercentage:(currentTimerValue /
                            startingTimerValue) * 100];
    
    if (currentTimerValue <= 3.0) {
        [skybox setColor:ccRED];
    }
    
    // Game Over / Time's Up
    if (currentTimerValue <= 0) {
        [self unscheduleUpdate];
        
        for (MXMoleHill *aHill in moleHillsInPlay) {
            [self resetMole:aHill];
        }
        isGameOver = YES;
        [self gameOver];
    }
}

#pragma mark Build The Screen
-(void) drawGround {
    // Randomly select a ground image
    NSString *groundName;
    NSInteger groundPick = CCRANDOM_0_1() * 2;
    
    switch (groundPick) {
        case 1:
            groundName = @"ground1.png";
            break;
        default: // Case 2 also falls through here
            groundName = @"ground2.png";
            break;
    }
    
    // Build the strips of ground from the selected image
    for (int i = 0; i < 5; i++) {
        CCSprite *groundStrip1 = [CCSprite
                spriteWithSpriteFrameName:groundName];
        [groundStrip1 setAnchorPoint:ccp(0.5,0)];
        [groundStrip1 setPosition:ccp(size.width/2,i*82)];
        [molesheet addChild:groundStrip1 z:4+((5-i) * 5)];
    }
    
    // Build a skybox
    skybox = [CCSprite
              spriteWithSpriteFrameName:@"skybox1.png"];
    [skybox setPosition:ccp(size.width/2,5*82)];
    [skybox setAnchorPoint:ccp(0.5,0)];
    [molesheet addChild:skybox z:1];
}


-(void) drawHills {
    NSInteger hillCounter = 0;
    NSInteger newHillZ = 6;
    
    // We want to draw a grid of 12 hills
    for (NSInteger row = 1; row <= 4; row++) {
        // Each row reduces the Z order
        newHillZ--;
        
        for (NSInteger col = 1; col <= 3; col++) {
            hillCounter++;

            // Build a new MXMoleHill
            MXMoleHill *newHill = [[MXMoleHill alloc] init];
            [newHill setPosition:[self
                hillPositionForRow:row andColumn:col]];
            [newHill setMoleHillBaseZ:newHillZ];
            [newHill setMoleHillTop:[CCSprite
                spriteWithSpriteFrameName:@"pileTop.png"]];
            [newHill setMoleHillBottom:[CCSprite
                spriteWithSpriteFrameName:@"pileBottom.png"]];
            [newHill setMoleHillID:hillCounter];
            
            // We position the two moleHill sprites so 
            // the "seam" is at the edge.  We use the
            // size of the top to position both, 
            // because the bottom image
            // has some overlap to add texture
            [[newHill moleHillTop] setPosition:
                ccp(newHill.position.x, newHill.position.y +
                [newHill moleHillTop].contentSize.height
                    / 2)];
            [[newHill moleHillBottom] setPosition:
                ccp(newHill.position.x, newHill.position.y - 
                [newHill moleHillTop].contentSize.height
                    / 2)];

            //Add the sprites to the batch node
            [molesheet addChild:[newHill moleHillTop]
                              z:(2 + (newHillZ * 5))];
            [molesheet addChild:[newHill moleHillBottom]
                              z:(5 + (newHillZ * 5))];
            
            //Set up a mole in the hill
            MXMole *newMole = [[MXMole alloc] init];
            [newHill setHillMole:newMole]; 
            [[newHill hillMole] setParentHill:newHill]; 
            [newMole release];

            // This flatlines the values for the new mole
            [self resetMole:newHill];

            [moleHillsInPlay addObject:newHill];
            [newHill release];
        }
    }
}

-(void) buildAnimations {
    // Load the Animation to the CCSpriteFrameCache
    NSMutableArray *frameArray = [NSMutableArray array];
    
    // Load the frames
    [frameArray addObject:[[CCSpriteFrameCache
            sharedSpriteFrameCache]
            spriteFrameByName:@"penguin_forward.png"]];
    [frameArray addObject:[[CCSpriteFrameCache
            sharedSpriteFrameCache]
            spriteFrameByName:@"penguin_left.png"]];
    [frameArray addObject:[[CCSpriteFrameCache
            sharedSpriteFrameCache]
            spriteFrameByName:@"penguin_forward.png"]];
    [frameArray addObject:[[CCSpriteFrameCache
            sharedSpriteFrameCache]
            spriteFrameByName:@"penguin_right.png"]];
    [frameArray addObject:[[CCSpriteFrameCache
            sharedSpriteFrameCache]
            spriteFrameByName:@"penguin_forward.png"]];
    [frameArray addObject:[[CCSpriteFrameCache
            sharedSpriteFrameCache]
            spriteFrameByName:@"penguin_forward.png"]];
    
    // Build the animation
    CCAnimation *newAnim = [CCAnimation
            animationWithSpriteFrames:frameArray delay:0.4];

    // Store it in the cache
    [[CCAnimationCache sharedAnimationCache]
            addAnimation:newAnim name:@"penguinAnim"];
}

#pragma mark Mole Handling
-(void) resetMole:(MXMoleHill*)moleHill {
    // Reset all mole-related values.
    // This allows us to keep reusing moles in the hills
    [[moleHill hillMole] stopAllActions];
	[[[moleHill hillMole] moleSprite]
                        removeFromParentAndCleanup:NO];
	[[moleHill hillMole] setMoleGroundY:0.0f];		
    [[moleHill hillMole] setMoleState:kMoleDead];
    [[moleHill hillMole] setIsSpecial:NO];
	[moleHill setIsOccupied:NO];
}

-(void) spawnMole:(id)sender {
    // Spawn a new mole from a random, unoccupied hill
	NSInteger newMoleHill;
	BOOL isApprovedHole = FALSE;
	NSInteger rand;
    
	if (molesInPlay == [moleHillsInPlay count] ||
        molesInPlay == maxMoles) {
		// Holes full, cannot spawn a new mole
	} else {
		// Loop until we pick a hill that isn't occupied
		do {
			rand = CCRANDOM_0_1() * maxHills;
			
			if (rand > maxHills) { rand = maxHills; }
			
            MXMoleHill *testHill = [moleHillsInPlay
                                    objectAtIndex:rand];
            
            // Look for an unoccupied hill
			if ([testHill isOccupied] == NO) {
				newMoleHill = rand;
				isApprovedHole = YES;
				[testHill setIsOccupied:YES];
			}
		} while (isApprovedHole == NO);
        
		// Mark that we have a new mole in play
		molesInPlay++;

		// Grab a handle on the mole Hill 
		MXMoleHill *thisHill = [moleHillsInPlay
                        objectAtIndex:newMoleHill];
		
		NSInteger hillZ = [thisHill moleHillBaseZ];
        
        // Set up the mole for this hill
        CCSprite *newMoleSprite = [CCSprite
                        spriteWithSpriteFrameName:
                                @"penguin_forward.png"];
        
        [[thisHill hillMole] setMoleSprite:newMoleSprite];		
		[[thisHill hillMole] setMoleState:kMoleAlive];
			
        // We keep track of where the ground level is
		[[thisHill hillMole] setMoleGroundY:
                                thisHill.position.y];
        
        // Set the position of the mole based on the hill
        float newMolePosX = thisHill.position.x;
        float newMolePosY = thisHill.position.y - 
        (newMoleSprite.contentSize.height/2);
        
		[newMoleSprite setPosition:ccp(newMolePosX,
                                       newMolePosY)];
        
        // See if we need this to be a "special" mole
        NSInteger moleRandomizer = CCRANDOM_0_1() * 100;
        
        // If we randomized under 5, make this special
        if (moleRandomizer < 5) {
            [[thisHill hillMole] setIsSpecial:YES];
        }
        
		//Trigger the new mole to raise
		[molesheet addChild:newMoleSprite
                          z:(3 + (hillZ * 5))];
		[self raiseMole:thisHill];
	}
}

-(void) raiseMole:(MXMoleHill*)aHill {
	// Grab the mole sprite
	CCSprite *aMole = [[aHill hillMole] moleSprite];
	
    float moleHeight = aMole.contentSize.height;
    
	// Define the hole wobble/jiggle
	CCMoveBy *wobbleHillLeft = [CCMoveBy
            actionWithDuration:.1 position:ccp(-3,0)];
	CCMoveBy *wobbleHillRight =[CCMoveBy
            actionWithDuration:.1 position:ccp(3,0)];
        
	// Run the actions for the hill
	[[aHill moleHillBottom] runAction:
            [CCSequence actions:wobbleHillLeft,
             wobbleHillRight, wobbleHillLeft,
             wobbleHillRight, nil]];

	// Define some mole actions.
    // We will only use some of them on each mole
	CCMoveBy *moveUp = [CCMoveBy
            actionWithDuration:moleRaiseTime
            position:ccp(0,moleHeight*.8)];
	CCMoveBy *moveUpHalf = [CCMoveBy
            actionWithDuration:moleRaiseTime
            position:ccp(0,moleHeight*.4)];
    CCDelayTime *moleDelay = [CCDelayTime
            actionWithDuration:moleDelayTime];
	CCMoveBy *moveDown = [CCMoveBy
            actionWithDuration:moleDownTime
            position:ccp(0,-moleHeight*.8)];
	CCCallFuncND *delMole = [CCCallFuncND
            actionWithTarget:self
            selector:@selector(deleteMole:data:)
            data:(MXMoleHill*)aHill];
    CCAnimate *anim = [CCAnimate
            actionWithAnimation:[[CCAnimationCache
            sharedAnimationCache]
            animationByName:@"penguinAnim"]];
    CCRotateBy *rot1 = [CCRotateBy
            actionWithDuration:moleDelayTime/3 angle:-20];
    CCRotateBy *rot2 = [CCRotateBy
            actionWithDuration:moleDelayTime/3 angle:40];
    CCRotateBy *rot3 = [CCRotateBy
            actionWithDuration:moleDelayTime/3 angle:-20];

    // We have 6 behaviors to choose from. Randomize.
    NSInteger behaviorPick = CCRANDOM_0_1() * 6;
    
    // If this is a special mole, let's control him better
    if ([aHill hillMole].isSpecial) {

        // Build some more actions for specials
        CCTintTo *tintR = [CCTintTo actionWithDuration:0.2
                        red:255.0 green:0.2 blue:0.2];
        CCTintTo *tintB = [CCTintTo actionWithDuration:0.2
                        red:0.2 green:0.2 blue:255.0];
        CCTintTo *tintG = [CCTintTo actionWithDuration:0.2
                        red:0.2 green:255.0 blue:0.2];
        
        // Set a color flashing behavior
        [aMole runAction:[CCRepeatForever
                actionWithAction:[CCSequence actions:
                tintR, tintB, tintG, nil]]];
        // Move up and down and rotate/wobble
        [aMole runAction:[CCSequence actions:moveUp, rot1,
                rot2, rot3, rot1, rot2, rot3, moveDown,
                delMole, nil]];
    } else {
        switch (behaviorPick) {
            case 1:
                // Move up and down and rotate/wobble
                [aMole runAction:[CCSequence actions:
                    moveUp, rot1, rot2, rot3, moveDown,
                    delMole, nil]];
                break;
            case 2:
                // Move up and then down without pausing
                [aMole runAction:[CCSequence actions:
                    moveUp, moveDown, delMole, nil]];
                break;
            case 3:
                // Move up halfway and then down
                [aMole runAction:[CCSequence actions:
                    moveUpHalf, moleDelay, moveDown,
                    delMole, nil]];
                break;
            case 4:
                // Move up halfway and then down, no pause
                [aMole runAction:[CCSequence actions:
                    moveUpHalf, moveDown, delMole, nil]];
                break;
            case 5:
                // Move up halfway, look around, then down
                [aMole runAction:[CCSequence actions:
                    moveUpHalf, anim, moveDown, delMole,
                    nil]];
                break;
            default:
                // Play the look around animation
                [aMole runAction:anim];
                // Move up and down
                [aMole runAction:[CCSequence actions:
                    moveUp, moleDelay, moveDown, delMole,
                    nil]];
                break;
        }
    }
}

-(void)deleteMole:(id)sender data:(MXMoleHill*)moleHill {
    // This function is named for the intent, but
    // moles are not deleted, they are just reset.
	molesInPlay--;
	[self resetMole:moleHill];
}

-(void) scoreMole:(MXMole*)aMole {
	// Make sure we don't have a dead mole
	if (aMole.moleState == kMoleDead) {
		return;
	}
    
	// Get the hill
	MXMoleHill *aHill = [aMole parentHill];
	
    // Add the score
    if (aMole.isSpecial) {
        // Specials score more points
        playerScore = playerScore + 5;
        // You get 5 extra seconds, too
        [self addTimeToTimer:5];
    } else {
        // Normal mole.  Add 1 point.
        playerScore++;
    }

    // Update the score display
    [self updateScore];

    // Set up the mole's move to the score
    CCMoveTo *moveMole = [CCMoveTo actionWithDuration:0.2f
            position:[self scorePosition]];
    CCScaleTo *shrinkMole = [CCScaleTo
            actionWithDuration:0.2f scale:0.5f];
    CCSpawn *shrinkAndScore = [CCSpawn
            actionOne:shrinkMole two:moveMole];
    CCCallFuncND *delMole = [CCCallFuncND
            actionWithTarget:self
            selector:@selector(deleteMole:data:)
            data:(MXMoleHill*)aHill];
    
    [aHill.hillMole.moleSprite stopAllActions];
    [aHill.hillMole.moleSprite runAction:[CCSequence
            actions: shrinkAndScore, delMole,  nil]];
}

#pragma mark Score Handlers
-(void) generateScoreDisplay {
    // Create the word "score"
    CCLabelTTF *scoreTitleLbl = [CCLabelTTF
            labelWithString:@"SCORE" fontName:@"AnuDaw"
            fontSize:20];
    [scoreTitleLbl setPosition:ccpAdd([self scorePosition],
            ccp(0,20))];
    [self addChild:scoreTitleLbl z:50];
    
    // Generate the display for the actual numeric score
    scoreLabel = [CCLabelTTF labelWithString:[NSString
            stringWithFormat:@"%i", playerScore]
            fontName:@"AnuDaw" fontSize:18];
    [scoreLabel setPosition:[self scorePosition]];
    [self addChild:scoreLabel z:50];
}

-(void) incrementScore {
    // Increment the score and update the display
    playerScore++;
    [self updateScore];
}

-(void) updateScore {
    // Update the score label with the new score value
    [scoreLabel setString:[NSString
                stringWithFormat:@"%i", playerScore]];
}

#pragma mark Timer Handlers
-(void) generateTimerDisplay {
    
    // Add a frame for the timer
    timerFrame = [CCSprite spriteWithFile:@"timer.png"];
    [timerFrame setPosition:[self timerPosition]];
    [self addChild:timerFrame z:8];
    
    // Add the timer itself
    CCSprite *timerImage = [CCSprite
                    spriteWithFile:@"timer_back.png"];
    
    timerDisplay = [CCProgressTimer
                    progressWithSprite:timerImage];
    [timerDisplay setPosition:[self timerPosition]];
    [timerDisplay setType:kCCProgressTimerTypeRadial];
    [self addChild:timerDisplay z:4];
    
    [timerDisplay setPercentage:100];
}

-(void) addTimeToTimer:(NSInteger)secondsToAdd {
    currentTimerValue = currentTimerValue + secondsToAdd;
}

-(void) gameOver {
    // Add a basic Game Over text
    CCLabelTTF *gameOverLabel = [CCLabelTTF
            labelWithString:@"Game Over"
            fontName:@"Marker Felt" fontSize:60];
    [gameOverLabel setPosition:ccp(size.width/2,
                                   size.height/2)];
    [self addChild:gameOverLabel z:50];
    
    // Add a second Game Over text, as a drop shadow
    CCLabelTTF *gameOverLabelShadow = [CCLabelTTF
            labelWithString:@"Game Over"
            fontName:@"Marker Felt" fontSize:60];
    [gameOverLabelShadow setPosition:ccp(size.width/2-4,
                                         size.height/2-4)];
    [gameOverLabelShadow setColor:ccBLACK];
    [self addChild:gameOverLabelShadow z:49];
}


#pragma mark Object Positions
-(CGPoint) hillPositionForRow:(NSInteger)row
                    andColumn:(NSInteger)col {
    float rowPos = row * 82;
    float colPos = 54 + ((col - 1) * 104);
    return ccp(colPos,rowPos); 
}

-(CGPoint) scorePosition {
    return ccp(size.width - 60, size.height - 40);
}

-(CGPoint) timerPosition {
    return ccp(size.width/2, size.height-30);
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
    CGPoint location = [touch locationInView:
                        [touch view]];
    CGPoint convLoc = [[CCDirector sharedDirector]
                       convertToGL:location];
    
    if (isGameOver) {
        [[SimpleAudioEngine sharedEngine]
                        playEffect:SND_BUTTON];
        [[CCDirector sharedDirector]
                        replaceScene:[MXMenuScene node]];
        return YES;
    }
    
    // If the back button was pressed, we exit
    if (CGRectContainsPoint([backButton boundingBox],
                            convLoc)) {
        [[SimpleAudioEngine sharedEngine]
                        playEffect:SND_BUTTON];
        [[CCDirector sharedDirector]
                        replaceScene:[MXMenuScene node]];
        return YES;
    }
    
    // Ignore this touch.
    return NO;
}

@end
