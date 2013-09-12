//
//  SNSnake.m
//  ch4-snake
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "SNSnake.h"
#import "SNPlayfieldLayer.h"

@implementation SNSnake

@synthesize snakebody;
@synthesize snakeSpeed = _snakeSpeed;
@synthesize snakeDirection = _snakeDirection;

+(id) createWithLayer:(SNPlayfieldLayer*)myLayer
           withLength:(NSInteger)startLength {
    return [[[self alloc] initWithLayer:myLayer
            withLength:startLength] autorelease];
}

-(id) initWithLayer:(SNPlayfieldLayer*)myLayer
                withLength:(NSInteger)startLength {
    if (self = [super init]) {
        
        // Keep a reference to the parent, so we can use
        // the parent layer's positioning method
        parentLayer = myLayer;

        // Set up the snakebody array
        snakebody = [[NSMutableArray alloc]
                     initWithCapacity:30];

        // Set the starting defaults
        headRow = 2;
        headColumn = 2;
        self.snakeSpeed = 0.3;
        self.snakeDirection = kUp;
        
        // Add the head
        [self addHead];
        
        // Add the requested number of body segments
        for (int i = 1; i < startLength; i++) {
            [self addSegment];
        }
    }
    return self;
}

-(void) dealloc {
    
    [snakebody removeAllObjects];
    [snakebody release];
    snakebody = nil;
    
    [super dealloc];
}

-(void) addHead {
    // Create the snake head
    SNSnakeSegment *newSeg = [SNSnakeSegment
            spriteWithSpriteFrameName:@"snakehead.png"];
    
    // We use the parent layer's positioning method, so we 
    // will still be in lockstep with the other objects, 
    // even if the positioning formula is altered
    CGPoint newPos = [parentLayer positionForRow:headRow
                                andColumn:headColumn];
    
    // Set up the snake's initial head position
    [newSeg setPosition:newPos];
    
    // We don't really need to set this, but we do anyway
    [newSeg setPriorPosition:newSeg.position];
    
    // The head has no parent segment
    [newSeg setParentSegment:nil];
    
    // Add the head to the snake array
    [snakebody addObject:newSeg];
    
    // Add the snake to the parent layer
    [parentLayer addChild:newSeg z:100];
}

-(void) addSegment {
    // Add a new segment to the snake, at the end
    
    // Create a new segment
    SNSnakeSegment *newSeg = [SNSnakeSegment
            spriteWithSpriteFrameName:@"snakebody.png"];

    // Get a reference to the last segment of the snake
    SNSnakeSegment *priorSeg = [snakebody objectAtIndex:
                                ([snakebody count] - 1)];
    
    // The new segment is positioned at the prior
    // position of the priorSeg
    [newSeg setPosition:[priorSeg position]];
    
    // We start with same position for both variables
    [newSeg setPriorPosition:[newSeg position]];
    
    // Connect this segment to the one in front of it
    [newSeg setParentSegment:priorSeg];
    
    // Add the segment to the body array
    [snakebody addObject:newSeg];
    
    // Add the segment to the game (parent) layer
    [parentLayer addChild:newSeg z:100-[snakebody count]];
}

-(void) move {
    CGPoint moveByCoords;
    // Based on the direction, set the coordinate change
    switch (self.snakeDirection) {
        case kUp:
            moveByCoords = ccp(0,gridSize);
            break;
        case kLeft:
            moveByCoords = ccp(-gridSize,0);
            break;
        case kDown:
            moveByCoords = ccp(0,-gridSize);
            break;
        case kRight:
            moveByCoords = ccp(gridSize,0);
            break;
        default:
            moveByCoords = ccp(0,0);
            break;
    }
    
    // Iterate through each segment and move it
    for (SNSnakeSegment *aSeg in snakebody) {
        if (aSeg.parentSegment == nil) {
            // Move the head by the specified amount
            [aSeg setPosition:ccpAdd(aSeg.position,
                                     moveByCoords)];
        } else {
            // Body segments move to the prior position 
            // of the segment ahead of it
            [aSeg setPosition:
                    aSeg.parentSegment.priorPosition];
        }
    }
}

#pragma mark Snake Turning
-(void) turnLeft {
    // Change to a new direction
    switch (self.snakeDirection) {
        case kUp:
            self.snakeDirection = kLeft;
            break;
        case kLeft:
            self.snakeDirection = kDown;
            break;
        case kDown:
            self.snakeDirection = kRight;
            break;
        case kRight:
            self.snakeDirection = kUp;
            break;
        default:
            break;
    } 
}

-(void) turnRight {
    // Change to a new direction
    switch (self.snakeDirection) {
        case kUp:
            self.snakeDirection = kRight;
            break;
        case kRight:
            self.snakeDirection = kDown;
            break;
        case kDown:
            self.snakeDirection = kLeft;
            break;
        case kLeft:
            self.snakeDirection = kUp;
            break;
        default:
            break;
    }    
}

-(void) deathFlash {
    // Establish a flashing/swelling animation of head
    CCTintTo *flashA = [CCTintTo actionWithDuration:0.2
                        red:255.0 green:0.0 blue:0.0];
    CCTintTo *flashB = [CCTintTo actionWithDuration:0.2
                        red:255.0 green:255.0 blue:255.0];
    CCScaleBy *scaleA = [CCScaleBy actionWithDuration:0.3
                        scale:2.0];
    CCScaleBy *scaleB = [CCScaleBy actionWithDuration:0.3
                        scale:0.5];
    
    SNSnakeSegment *head = [snakebody objectAtIndex:0];
    
    // We repeat these 2 sequences forever
    [head runAction:[CCRepeatForever actionWithAction:
            [CCSequence actions:flashA, flashB, nil]]];
    [head runAction:[CCRepeatForever actionWithAction:
            [CCSequence actions:scaleA, scaleB, nil]]];
}

@end
