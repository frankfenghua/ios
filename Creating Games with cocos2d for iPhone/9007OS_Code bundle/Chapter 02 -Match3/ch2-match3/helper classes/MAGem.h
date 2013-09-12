//
//  MAGem.h
//  ch2-match3
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class MAPlayfieldLayer;

typedef enum {
    kGemAnyType = 0,
    kGem1,
    kGem2,
    kGem3,
    kGem4,
    kGem5,
    kGem6,
    kGem7
} GemType;

typedef enum {
    kGemIdle = 100,
    kGemMoving,
    kGemScoring,
    kGemNew
} GemState;

@interface MAGem : CCSprite {
    NSInteger _rowNum; // Row number for this gem
    NSInteger _colNum; // Column number for this gem
    
    GemType _gemType; // The enum value of the gem
    
    GemState _gemState; // The current state of the gem

    MAPlayfieldLayer *gameLayer; // The game layer
    
}

@property (nonatomic, assign) NSInteger rowNum;
@property (nonatomic, assign) NSInteger colNum;
@property (nonatomic, assign) GemType gemType;
@property (nonatomic, assign) GemState gemState;
@property (nonatomic, assign) MAPlayfieldLayer *gameLayer;

-(BOOL) isGemSameAs:(MAGem*)otherGem;
-(BOOL) isGemInSameRow:(MAGem*)otherGem;
-(BOOL) isGemInSameColumn:(MAGem*)otherGem;
-(BOOL) isGemBeside:(MAGem*)otherGem;

-(void) highlightGem;
-(void) stopHighlightGem;

- (BOOL) containsTouchLocation:(CGPoint)pos;
@end
