//
//  CoinsGame.m
//  Sample 04
//
//  Created by Lucas Jordan on 4/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CoinsGame.h"


@implementation CoinsGame
@synthesize coins;
@synthesize remaingTurns;
@synthesize score;
@synthesize colCount;
@synthesize rowCount;


-(id)initRandomWithRows:(int)rows Cols:(int)cols{
    
    self = [super init];
    if (self != nil){
        coins = [NSMutableArray new];
        
        colCount = cols;
        rowCount = rows;
        
        int numberOfCoins = colCount*rowCount;
        
        for (int i=0;i<numberOfCoins;i++){
            int result = arc4random()%3;
            [coins addObject:[NSNumber numberWithInt:result]];
        }
        
        //Insure we don't start with any matching rows and cols.
        NSMutableArray* matchingRows = [self findMatchingRows];
        NSMutableArray* matchingCols = [self findMatchingCols];
        while ([matchingCols count] > 0 || [matchingRows count] > 0){
            [self randomizeRows: matchingRows];
            [self randomizeCols: matchingCols];
            
            matchingRows = [self findMatchingRows];
            matchingCols = [self findMatchingCols];
        }
        
        remaingTurns = 10;
        score = 0;
    }
    return self;
}

-(NSNumber*)coinForCoord:(Coord)coord{
    int index = [self indexForCoord:coord];
    return [coins objectAtIndex:index];
}
-(int)indexForCoord:(Coord)coord{
    return coord.row*colCount + coord.col;
}
-(void)swap:(Coord)coordA With:(Coord)coordB{
    int indexA = [self indexForCoord:coordA];
    int indexB = [self indexForCoord:coordB];
    
    NSNumber* coinA = [coins objectAtIndex:indexA];
    NSNumber* coinB = [coins objectAtIndex:indexB];
    
    [coins replaceObjectAtIndex:indexA withObject:coinB];
    [coins replaceObjectAtIndex:indexB withObject:coinA];
    
}
-(NSMutableArray*)findMatchingRows{
    NSMutableArray* matchingRows = [NSMutableArray new];
    
    for (int r=0;r<rowCount;r++){
        NSNumber* coin0 = [self coinForCoord:CoordMake(r, 0)];
        BOOL mismatch = false;    
        
        for (int c=1;c<colCount;c++){
            NSNumber* coinN = [self coinForCoord:CoordMake(r,c)];
            if (![coin0 isEqual:coinN]){
                mismatch = true;
                break;
            }
        }
        if (!mismatch){
            [matchingRows addObject:[NSNumber numberWithInt:r]];
        }
    }
    
    return matchingRows;
}
-(NSMutableArray*)findMatchingCols{
    NSMutableArray* matchingCols = [NSMutableArray new];
    
    for (int c=0;c<colCount;c++){
        NSNumber* coin0 = [self coinForCoord:CoordMake(0, c)];
        BOOL mismatch = false;    
        
        for (int r=1;r<rowCount;r++){
            NSNumber* coinN = [self coinForCoord:CoordMake(r,c)];
            if (![coin0 isEqual:coinN]){
                mismatch = true;
                break;
            }
        }
        if (!mismatch){
            [matchingCols addObject:[NSNumber numberWithInt:c]];
        }
    }
    
    return matchingCols;
}
-(void)randomizeRows:(NSMutableArray*)matchingRows{
    for (NSNumber* row in matchingRows){
        for (int c=0;c<colCount;c++){
            int index = [self indexForCoord:CoordMake([row intValue], c)];
            int newCoin = arc4random()%3;
            [coins replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:newCoin]];
        }
    }
}
-(void)randomizeCols:(NSMutableArray*)matchingCols{
    for (NSNumber* col in matchingCols){
        for (int r=0;r<rowCount;r++){
            int index = [self indexForCoord:CoordMake(r, [col intValue])];
            int newCoin = arc4random()%3;
            [coins replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:newCoin]];
        }
    }
}

- (void)encodeWithCoder:(NSCoder *)encoder{
    
    [encoder encodeObject:coins forKey:@"coins"];
    [encoder encodeInt:remaingTurns forKey:@"remaingTurns"];
    [encoder encodeInt:score forKey:@"score"];
    [encoder encodeInt:colCount forKey:@"colCount"];
    [encoder encodeInt:rowCount forKey:@"rowCount"];
    
}
- (id)initWithCoder:(NSCoder *)decoder{
    
    coins = [[decoder decodeObjectForKey:@"coins"] retain];
    remaingTurns = [decoder decodeIntForKey:@"remaingTurns"];
    score = [decoder decodeIntForKey:@"score"];
    colCount = [decoder decodeIntForKey:@"colCount"];
    rowCount = [decoder decodeIntForKey:@"rowCount"];
    
    return self;
}
@end
