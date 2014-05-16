//
//  Grid.h
//
//  CS193p Fall 2013
//  Copyright (c) 2013 Stanford University.
//  All rights reserved.
//

#import <Foundation/Foundation.h>

// To use Grid, simply alloc/init one, then
//  decide what aspect ratio you want the things in the grid to have (cellAspectRatio)
//  and how much space you want the grid to take up in total (size)
//  then specify what is the minimum number of cells in the grid you require (minimumNumberOfCells)
//
// After you set those three things above, then you can find out where each cell is either by ...
// ... its center (centerOfCellAtRow:inColumn:)
// ... or its frame (frameOfCellAtRow:inColumn:)
//
// You can also find out how many rows (rowCount) or columns (columnCount) are in the grid
//  and how big each cell is (they will all be the same size)
//
// inputsAreValid will tell you whether your 3 inputs are okay
//
// Setting minimum cell widths and heights is completely optional ({min,max}Cell{Width,Height})

@interface Grid : NSObject

// required inputs (zero is not a valid value for any of these)

@property (nonatomic) CGSize size;                      // overall available space to put grid into
@property (nonatomic) CGFloat cellAspectRatio;          // width divided by height (of each cell)
@property (nonatomic) NSUInteger minimumNumberOfCells;

// optional inputs (non-positive values are ignored)

@property (nonatomic) CGFloat minCellWidth;
@property (nonatomic) CGFloat maxCellWidth;     // ignored if less than minCellWidth
@property (nonatomic) CGFloat minCellHeight;
@property (nonatomic) CGFloat maxCellHeight;    // ignored if less than minCellHeight

// calculated outputs (value of NO or 0 or CGSizeZero means "invalid inputs")

@property (nonatomic, readonly) BOOL inputsAreValid;    // cells will fit into requested size

@property (nonatomic, readonly) CGSize cellSize;        // will be made as large as possible
@property (nonatomic, readonly) NSUInteger rowCount;
@property (nonatomic, readonly) NSUInteger columnCount;

// origin row and column are zero

- (CGPoint)centerOfCellAtRow:(NSUInteger)row inColumn:(NSUInteger)column;
- (CGRect)frameOfCellAtRow:(NSUInteger)row inColumn:(NSUInteger)column;

@end
