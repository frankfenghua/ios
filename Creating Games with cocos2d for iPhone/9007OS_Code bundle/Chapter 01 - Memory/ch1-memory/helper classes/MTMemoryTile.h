//
//  MTMemoryTile.h
//  ch1-memory
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

// MemoryTile is a subclass of CCSprite

@interface MTMemoryTile : CCSprite {
    NSInteger _tileRow;
    NSInteger _tileColumn;
    
    NSString *_faceSpriteName;
    
    BOOL isFaceUp;
}

@property (nonatomic, assign) NSInteger tileRow;
@property (nonatomic, assign) NSInteger tileColumn;
@property (nonatomic, assign) BOOL isFaceUp;
@property (nonatomic, retain) NSString *faceSpriteName;

// Exposed methods to interact with the tile
-(void) showFace;
-(void) showBack;
-(void) flipTile;
-(BOOL) containsTouchLocation:(CGPoint)pos;

@end
