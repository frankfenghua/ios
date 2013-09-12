//
//  TDEnemy.m
//  ch8-shooter
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "TDEnemySmart.h"
#import "TDPlayfieldLayer.h"

#define kMovingSpeed  0.4

@implementation TDEnemySmart

@synthesize spOpenSteps;
@synthesize spClosedSteps;
@synthesize shortestPath;
@synthesize currentStepAction;
@synthesize pendingMove;


-(void) onEnterTransitionDidFinish {
    spOpenSteps = nil;
    spClosedSteps = nil;
    shortestPath = nil;
    currentStepAction = nil;
    pendingMove = nil;
    
    maxShootSpeed = 0.3;
    pathTimer = 1;
    
    isUsingPathfinding = NO;
    
    [super onEnterTransitionDidFinish];
}

-(void) buildEnemySpriteAtPos:(CGPoint)pos {
    sprite = [CCSprite spriteWithSpriteFrameName:IMG_ENEMYSMART];
    [sprite setPosition:pos];
}


-(void) update:(ccTime)dt {
    pathTimer = pathTimer - dt;
    currShootSpeed = currShootSpeed - dt;
    
    if (ccpDistance(sprite.position, [parentLayer getHeroPos]) < 250) {
        // Limit the shoot speed
        if (currShootSpeed <= 0) {
            // Ready to shoot
            [self shoot];
            currShootSpeed = maxShootSpeed;
        }
    }
    
    // If not using A* pathfinding, move toward hero
    if (isUsingPathfinding == NO) {
        [self moveToward:[parentLayer getHeroPos]];
    }
}

-(void) moveTowardHero {
    [self moveToward:[parentLayer getHeroPos]];
}

-(void) moveToward:(CGPoint)target {
    // Rotate toward player
    [self rotateToTarget:target];
    
    // Move toward the player
    CGFloat targetAngle = CC_DEGREES_TO_RADIANS(-1 *
                                                sprite.rotation);
    CGPoint targetPoint = ccpForAngle(targetAngle);
    CGPoint finalTarget = ccpAdd(targetPoint, sprite.position);
    
    CGPoint tileCoord = [parentLayer tileCoordForPos:finalTarget];
    
    if ([parentLayer isWallAtTileCoord:tileCoord]) {
        // Cannot move - hit a wall
        // Use A* pathfinding to find a way around
        isUsingPathfinding = YES;
        [self moveTowardWithPathfinding:target];
        return;
    }
    
    // Set the new position
    sprite.position = finalTarget;
    
}

-(void) dealloc {
    [self unscheduleUpdate];

    [spOpenSteps release];
	[spClosedSteps release];
	[shortestPath release];
	[currentStepAction release];
	[pendingMove release];
    
    [super dealloc];
}

#pragma mark A* Pathfinding
// All A* pathfinding-related code is used
// with permission of the author, Johann Fradj
// From a tutorial published at:
// http://www.raywenderlich.com

// Some modifications made to customize it for this
// project

- (void)moveTowardWithPathfinding:(CGPoint)target
{
    [self rotateToTarget:target];
    
	// Start by stopping the current moving action
    if (currentStepAction) {
        self.pendingMove = [NSValue valueWithCGPoint:target];
        return;
    }
	
	// Init shortest path properties
	self.spOpenSteps = [NSMutableArray array];
	self.spClosedSteps = [NSMutableArray array];
	self.shortestPath = nil;

	// Get current tile coordinate and desired tile coord
	CGPoint fromTileCoord = [parentLayer tileCoordForPos:sprite.position];
    CGPoint toTileCoord = [parentLayer tileCoordForPos:target];
	
	// Check that there is a path to compute ;-)
	if (CGPointEqualToPoint(fromTileCoord, toTileCoord)) {
		return;
	}
	
	// Start by adding the from position to the open list
	[self insertInOpenSteps:[[[AStarNode alloc] initWithPosition:fromTileCoord] autorelease]];
	
	do {
		// Get the lowest F cost step
		// Because the list is ordered, the first step is always the one with the lowest F cost
		AStarNode *currentStep = [self.spOpenSteps objectAtIndex:0];
        
		// Add the current step to the closed set
		[self.spClosedSteps addObject:currentStep];
        
		// Remove it from the open list
		// Note that if we wanted to first removing from the open list, care should be taken to the memory
		[self.spOpenSteps removeObjectAtIndex:0];
		
		// If the currentStep is at the desired tile coordinate, we have done
		if (CGPointEqualToPoint(currentStep.position, toTileCoord)) {
			[self constructPathAndStartAnimationFromStep:currentStep];
			self.spOpenSteps = nil; // Set to nil to release unused memory
			self.spClosedSteps = nil; // Set to nil to release unused memory
			break;
		}
		
		// Get the adjacent tiles coord of the current step
		NSArray *adjSteps = [parentLayer walkableAdjacentTilesCoordForTileCoord:currentStep.position];
		for (NSValue *v in adjSteps) {
            
			AStarNode *step = [[AStarNode alloc] initWithPosition:[v CGPointValue]];
			
			// Check if the step isn't already in the closed set
			if ([self.spClosedSteps containsObject:step]) {
				[step release]; // Must releasing it to not leaking memory ;-)
				continue; // Ignore it
			}
			
			// Compute the cost form the current step to that step
			int moveCost = [self costToMoveFromStep:currentStep toAdjacentStep:step];
			
			// Check if the step is already in the open list
			NSUInteger index = [self.spOpenSteps indexOfObject:step];
			
			if (index == NSNotFound) { // Not on the open list, so add it
				
				// Set the current step as the parent
				step.parent = currentStep;
                
				// The G score is equal to the parent G score + the cost to move from the parent to it
				step.gScore = currentStep.gScore + moveCost;
				
				// Compute the H score which is the estimated movement cost to move from that step to the desired tile coordinate
				step.hScore = [self computeHScoreFromCoord:step.position toCoord:toTileCoord];
				
				// Adding it with the function which is preserving the list ordered by F score
				[self insertInOpenSteps:step];
				
				// Done, now release the step
				[step release];
			}
			else { // Already in the open list
				
				[step release]; // Release the freshly created one
				step = [self.spOpenSteps objectAtIndex:index]; // To retrieve the old one (which has its scores already computed ;-)
				
				// Check to see if the G score for that step is lower if we use the current step to get there
				if ((currentStep.gScore + moveCost) < step.gScore) {
					
					// The G score is equal to the parent G score + the cost to move from the parent to it
					step.gScore = currentStep.gScore + moveCost;
					
					// Because the G Score has changed, the F score may have changed too
					// So to keep the open list ordered we have to remove the step, and re-insert it with
					// the insert function which is preserving the list ordered by F score
					
					// We have to retain it before removing it from the list
					[step retain];
					
					// Now we can removing it from the list without be afraid that it can be released
					[self.spOpenSteps removeObjectAtIndex:index];
					
					// Re-insert it with the function which is preserving the list ordered by F score
					[self insertInOpenSteps:step];
					
					// Now we can release it because the oredered list retain it
					[step release];
				}
			}
		}
		
	} while ([self.spOpenSteps count] > 0);
}

// Insert a path step (ShortestPathStep) in the ordered open steps list (spOpenSteps)
- (void)insertInOpenSteps:(AStarNode*)step
{
	int stepFScore = [step fScore]; // Compute only once the step F score's
	int count = [self.spOpenSteps count];
	int i = 0; // It will be the index at which we will insert the step
	for (; i < count; i++) {
		if (stepFScore <= [[self.spOpenSteps objectAtIndex:i] fScore]) { // if the step F score's is lower or equals to the step at index i
			// Then we found the index at which we have to insert the new step
			break;
		}
	}
	// Insert the new step at the good index to preserve the F score ordering
	[self.spOpenSteps insertObject:step atIndex:i];
}

// Compute the H score from a position to another
//  (from the current position to the final desired position
- (int)computeHScoreFromCoord:(CGPoint)fromCoord
                      toCoord:(CGPoint)toCoord
{
	// Manhattan method
	return abs(toCoord.x - fromCoord.x) +
            abs(toCoord.y - fromCoord.y);
    
}

// Compute the cost of moving from a step to an adjecent one
- (int)costToMoveFromStep:(AStarNode*)fromStep
           toAdjacentStep:(AStarNode*)toStep
{
	return ((fromStep.position.x != toStep.position.x) &&
        (fromStep.position.y != toStep.position.y)) ? 14 : 10;
}


// Go backward from a step (the final one) to reconstruct the shortest computed path
- (void)constructPathAndStartAnimationFromStep:(AStarNode*)step
{
	self.shortestPath = [NSMutableArray array];
	
	do {
		if (step.parent != nil) { // Don't add the last step
            // which is the start position (remember we go backward,
            //so the last one is the origin position ;-)
			[self.shortestPath insertObject:step atIndex:0];
            // Always insert at index 0 to reverse the path
		}
		step = step.parent; // Go backward
	} while (step != nil); // Until there is not more parent
	
	// Call the popStepAndAnimate to initiate the animations
	[self popStepAndAnimate];
}

// Callback which will be called at the end of each animated step along the computed path
- (void)popStepAndAnimate
{
    self.currentStepAction = nil;
    
    // Check if there is a pending move
    if (self.pendingMove != nil) {
        //CGPoint moveTarget = [pendingMove CGPointValue];
        self.pendingMove = nil;
		self.shortestPath = nil;
        isUsingPathfinding = NO;
        //[self moveToward:moveTarget];
        return;
    }
    
	// Check if there is still shortestPath
	if (self.shortestPath == nil) {
        // Calc a new route so we don't sit idle
        isUsingPathfinding = NO;
        [self moveToward:[parentLayer getHeroPos]];
		return;
	}
	
	// Check if there remains path steps to go trough
	if ([self.shortestPath count] == 0) {
        isUsingPathfinding = NO;
		self.shortestPath = nil;
		return;
	}
	
	// Get the next step to move to
	AStarNode *s = [self.shortestPath objectAtIndex:0];
    
	// Prepare the action and the callback
	id moveAction = [CCMoveTo actionWithDuration:kMovingSpeed
                    position:[parentLayer
                              posForTileCoord:s.position]];
	id moveCallback = [CCCallFunc actionWithTarget:self
                    selector:@selector(popStepAndAnimate)];
                    // set the method itself as the callback
	self.currentStepAction = [CCSequence actions:moveAction,
                              moveCallback, nil];
	
	// Remove the step
	[self.shortestPath removeObjectAtIndex:0];
	
	// Play actions
	[sprite runAction:currentStepAction];
}


@end
