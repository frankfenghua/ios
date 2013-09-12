//
//  MAGem.m
//  ch2-match3
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "MAGem.h"

@implementation MAGem

@synthesize rowNum = _rowNum;
@synthesize colNum = _colNum;
@synthesize gemType = _gemType;
@synthesize gemState = _gemState;

@synthesize gameLayer;

-(BOOL) isGemSameAs:(MAGem*)otherGem {
    // Is the gem the same type as the other Gem?
    return (self.gemType == otherGem.gemType);
}

-(BOOL) isGemInSameRow:(MAGem*)otherGem {
    // Is the gem in the same row as the other Gem?
    return (self.rowNum == otherGem.rowNum);
}

-(BOOL) isGemInSameColumn:(MAGem*)otherGem {
    // Is the gem in the same column as the other gem?
    return (self.colNum == otherGem.colNum);
}

-(BOOL) isGemBeside:(MAGem*)otherGem {
    // If the row is the same, and the other gem is 
    // +/- 1 column, they are neighbors
    if ([self isGemInSameRow:otherGem] && 
        ((self.colNum == otherGem.colNum - 1) || 
        (self.colNum == otherGem.colNum + 1))
        ) {
        return YES;
    }
    // If the column is the same, and the other gem is 
    // +/- 1 row, they are neighbors
    else if ([self isGemInSameColumn:otherGem] && 
                 ((self.rowNum == otherGem.rowNum - 1) || 
                  (self.rowNum == otherGem.rowNum + 1))
                 ) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark Animate the touch
-(void) highlightGem {
    // Build a simple repeating "wobbly" animation
    CCMoveBy *moveUp = [CCMoveBy actionWithDuration:0.1
                        position:ccp(0,3)];
    CCMoveBy *moveDown = [CCMoveBy actionWithDuration:0.1
                        position:ccp(0,-3)];
    CCSequence *moveAround = [CCSequence actions:moveUp,
                        moveDown, nil];
    CCRepeatForever *gemHop = [CCRepeatForever
                        actionWithAction:moveAround];
    
    [self runAction:gemHop];
}

-(void) stopHighlightGem {
    // Stop all actions (the wobbly) on the gem
    [self stopAllActions];

    // We call to the gameLayer itself to make sure we 
    // haven't left the gem a little off-base
    // (from the highlightGem movements)
    [gameLayer performSelector:@selector(resetGemPosition:)
                    withObject:self];
}


#pragma mark Touch Detection
- (BOOL)containsTouchLocation:(CGPoint)pos
{
    // Was this gem touched?
	return CGRectContainsPoint(self.boundingBox, pos);
}

-(void) dealloc {
    [self setGameLayer:nil];
    
    [super dealloc];
}

@end
