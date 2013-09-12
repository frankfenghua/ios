//
//  MTPlayfieldLayer.h
//  ch1-memory
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MTMemoryTile.h"
#import "SimpleAudioEngine.h"
#import "MTMenuScene.h"

@interface MTPlayfieldLayer : CCLayer {
    CGSize size; // The window size from CCDirector

    CCSpriteBatchNode *memorysheet;
    
    CGSize tileSize; // Size (in points) of the tiles
    
    NSMutableArray *tilesAvailable;
    NSMutableArray *tilesInPlay;
    NSMutableArray *tilesSelected; 

    CCSprite *backButton;
    
    NSInteger maxTiles;
    
    float boardWidth; // Max width of the game board
    float boardHeight; // Max height of the game board
    
    NSInteger boardRows; // Total rows in the grid
    NSInteger boardColumns; // Total columns in the grid

    NSInteger boardOffsetX; // Offset from the left
    NSInteger boardOffsetY; // Offset from the bottom

    NSInteger padWidth; // Space between tiles
    NSInteger padHeight; // Space between tiles
    
    NSInteger playerScore; // Current score value
    CCLabelTTF *playerScoreDisplay; // Score label

    NSInteger livesRemaining; // Lives value
    CCLabelTTF *livesRemainingDisplay; // Lives label
    
    BOOL isGameOver;
}

+(id) layerWithRows:(NSInteger)numRows
         andColumns:(NSInteger)numCols;

@end
