//
//  CoinsGame.h
//  Sample 04
//
//  Created by Lucas Jordan on 4/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define COIN_TRIANGLE 0
#define COIN_SQUARE 1
#define COIN_CIRCLE 2

struct Coord {
    int row;
    int col;
};
typedef struct Coord Coord;

CG_INLINE Coord
CoordMake(int r, int c)
{
    Coord coord;
    coord.row = r;
    coord.col = c;
    return coord;
}

CG_INLINE BOOL
CoordEqual(Coord a, Coord b)
{
    return a.col == b.col && a.row == b.row;
}


@interface CoinsGame : NSObject <NSCoding>{
    NSMutableArray* coins;
    int remaingTurns;
    int score;
    int colCount;
    int rowCount;
}
@property (nonatomic, retain)  NSMutableArray* coins;
@property (nonatomic) int remaingTurns;
@property (nonatomic) int score;
@property (nonatomic) int colCount;
@property (nonatomic) int rowCount;

-(id)initRandomWithRows:(int)rows Cols:(int)cols;

-(NSNumber*)coinForCoord:(Coord)coord;
-(int)indexForCoord:(Coord)coord;

-(void)swap:(Coord)coordA With:(Coord)coordB;
-(NSMutableArray*)findMatchingRows;
-(NSMutableArray*)findMatchingCols;
-(void)randomizeRows:(NSMutableArray*)matchingRows;
-(void)randomizeCols:(NSMutableArray*)matchingCols;


@end
