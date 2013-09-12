//
//  OPRulesBase.mm
//  ch7-pool
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "OPRulesBase.h"
#import "OPBall.h"

@implementation OPRulesBase

@synthesize rackStyle;
@synthesize lastBall;
@synthesize orderedBalls;
@synthesize gameMode;
@synthesize replaceBalls;

@synthesize currentPlayer;
@synthesize isTableScratch;
@synthesize player1Goal;
@synthesize player2Goal;
@synthesize nextOrderedBall;

#pragma mark Loading Rules
-(id) initWithRulesForGame:(NSString*)gameName {
    if(self = [super init]) {
        // Load the rules for the game chosen
        [self loadRulesWith:gameName];
        
        isTableScratch = NO;
        isBreak = YES;
        
    }
    return self;
}

-(void) loadRulesWith:(NSString*)listKey {
    
    // Load the rules plist
    NSDictionary *ruleBook = [NSDictionary
                dictionaryWithDictionary:
                [self getDictionaryFromPlist:@"rules"]];

    NSDictionary *theseRules = [NSDictionary
                dictionaryWithDictionary:
                [ruleBook objectForKey:listKey]];

    self.rackStyle = [self convertRackType:
                [theseRules objectForKey:@"RackStyle"]];
    self.lastBall = (BallID)[[theseRules
                objectForKey:@"LastBall"] integerValue];
    self.orderedBalls = [[theseRules
                objectForKey:@"OrderedBalls"] boolValue];
    self.gameMode = [self convertGameMode:[theseRules
                objectForKey:@"GameMode"]];
    self.replaceBalls = [[theseRules
                objectForKey:@"ReplaceBalls"] boolValue];
    
    player1Goal = gameMode;
    player2Goal = gameMode;
    
    if (self.gameMode == kOrdered) {
        nextOrderedBall = kBallOne;
    }
    
    currentPlayer = 1;
}

-(RackLayoutType) convertRackType:(NSString*)rackStr {
    if ([rackStr isEqualToString:@"kRackDiamond"]) {
        return kRackDiamond;
    } else if ([rackStr isEqualToString:@"kRackTriangle"]) {
        return kRackTriangle;
    } else {
        NSLog(@"unknown rack type %@ in the plist.", rackStr);
    }
    return kRackFailed;
}

-(GameMode) convertGameMode:(NSString*)gameStr {
    if ([gameStr isEqualToString:@"Ordered"]) {
        return kOrdered;
    }
    else if ([gameStr isEqualToString:@"StripesVsSolids"]) {
        return kStripesVsSolids;
    }
    return kNone;
}

#pragma mark Plist loaders
-(id) readPlist:(NSString*) fileName {
	NSData *plistData;
	NSString *error;
	NSPropertyListFormat format;
	id plist;
	
    // Assumes filename is part of the main bundle
	NSString *localizedPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
	plistData = [NSData dataWithContentsOfFile:localizedPath];
	
	plist = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
	
	if (!plist) {
		NSLog(@"Error reading plist from file '%s', error '%s'", [localizedPath UTF8String], [error UTF8String]);
	}
	
	return plist;
}

-(NSDictionary*)getDictionaryFromPlist:(NSString*)fileName {
    return (NSDictionary*)[self readPlist:fileName];
}

-(GameMode) getCurrentPlayerGoal {
    if (currentPlayer == 1) {
        return player1Goal;
    } else {
        return player2Goal;
    }
}

#pragma mark Applied Rules
-(BOOL) isLegalFirstHit:(BallID)firstBall {
    // Reset the value
    isTableScratch = NO;
    
    if (firstBall == kBallNone) {
        // Table scratch if nothing touched
        isTableScratch = YES;
        return NO;
    }
    GameMode currGoal = [self getCurrentPlayerGoal];

    switch (currGoal) {
        case kStripesVsSolids:
            // lastBall cannot be hit first
            return firstBall != kBallEight;
        case kStripes:
            // Striped ball hit first to be legal.
            return firstBall > kBallEight;
        case kSolids:
            // Solid ball hit first to be legal.
            return firstBall < kBallEight;
        case kOrdered:
            if (firstBall == nextOrderedBall || isBreak) {
                // The correct next number was hit first,
                // Or this was the break shot
                isBreak = NO;
                return YES;
            }
            break;
        default:
            // No goal set, all balls are legal
            return NO;
            break;
    }
    return NO;
}

-(BOOL) didSinkValidBall:(NSArray*)ballArray {
    GameMode currGoal = [self getCurrentPlayerGoal];
    
    for (OPBall *aBall in ballArray) {
        switch (currGoal) {
            case kStripes:
                // Striped ball dropped to be legal.
                return aBall.tag > kBallEight;
            case kSolids:
                // Solid ball dropped to be legal.
                return aBall.tag < kBallEight;
            case kOrdered:
                // The correct next number must be sunk.
                return aBall.tag == nextOrderedBall;
            case kStripesVsSolids:
                // lastBall cannot be hit first
                // everything else is valid
                if (aBall.tag == lastBall) {
                    return NO;
                } else {
                    return YES;
                }
                break;
            default:
                // No goal set, all balls are legal
                return NO;
                break;
        }
    }
    return NO;
}

-(BOOL) didSinkLastBall:(NSArray*)ballArray {
    
    for (OPBall *aBall in ballArray) {
        if (aBall.tag == lastBall) {
            return YES;
        }
    }
    // Last ball not sunk
    return NO;
}

-(BOOL) didSinkCueBall:(NSArray*)ballArray {
    for (OPBall *aBall in ballArray) {
        if (aBall.tag == kBallCue) {
            return YES;
        }
    }
    // Cue ball not sunk
    return NO;
}

-(BOOL) isValidLastBall:(NSArray*)ballsSunk withBallsOnTable:(NSArray*)ballsOnTable {
    // Are all other balls for this player sunk already?
    GameMode currGoal = [self getCurrentPlayerGoal];
    
    switch (currGoal) {
        case kSolids:
            for (OPBall *aBall in ballsOnTable) {
                if (aBall.tag < lastBall) {
                    // Solids left on table.  Illegal.
                    return NO;
                }
            }
            return YES;
            break;
        case kStripes:
            for (OPBall *aBall in ballsOnTable) {
                if (aBall.tag > lastBall && aBall.tag < 100) {
                    // Solids left on table.  Illegal.
                    return NO;
                }
            }
            return YES;
            break;
        case kOrdered:
            for (OPBall *aBall in ballsOnTable) {
                if (aBall.tag != lastBall && aBall.tag < 100) {
                    // Balls left on table.  Illegal.
                    return NO;
                }
            }
            return YES;
            break;
        default:
            return NO;
            break;
    }
    return NO;
}

-(void) findNextOrderedBall:(NSArray*)tableBalls {
    // Look for each ball, from lowest to highest
    for (int i = 1; i < 16; i++) {
        for (OPBall *aBall in tableBalls) {
            if (aBall.tag == i) {
                nextOrderedBall = (BallID)i;
                return;
            }
        }
    }
}


@end
