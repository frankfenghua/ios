//
//  ERPlayfieldLayer.h
//  ch9-run
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "ERDefinitions.h"
#import "ERHero.h"
#import "ERTile.h"
#import "ERHUDLayer.h"
#import "ERBullet.h"
#import "EREnemy.h"
#import "ERBackground.h"

@interface ERPlayfieldLayer : CCLayer {
    
    CGSize size;

    CCSpriteBatchNode *runnersheet;
    
    ERHUDLayer *hudLayer;
    
    ERBackground *background1;
    ERBackground *background2;
    
    BOOL isGameOver;
    BOOL preventTouches;
    
    ERHero *hero;
    ccTime jumpTimer;
    ccTime maxJumpTimer;
    
    NSMutableArray *bulletArray;
    NSMutableArray *grndArray;
    NSMutableArray *enemyArray;
    NSMutableArray *bulletsToDelete;
    NSMutableArray *enemiesToDelete;
    NSMutableArray *grndToDelete;
    NSMutableArray *platformStack;
    
    NSInteger tileSize;
    float scrollSpeed;
    BOOL isScrolling;
    
    float distanceTravelled;
    
    float maxTileX;
    
    BOOL allowDoubleJump;
    
}

@property (nonatomic, assign) BOOL isGameOver;
@property (nonatomic, assign) BOOL preventTouches;

-(void) addBullet:(ERBullet*) thisBullet;

-(void) gameOver;

-(CCAnimate*) getAnim:(NSString*)animNm;

-(void) buildCacheAnimation:(NSString*) AnimName
           forFrameNameRoot:(NSString*) root
              withExtension:(NSString*) ext
                 frameCount:(NSInteger) count
                  withDelay:(float)delay;

@end
