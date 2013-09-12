//
//  TDPlayfieldLayer.h
//  ch8-shooter
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TDDefinitions.h"
#import "SneakyJoystick.h"
#import "TDBullet.h"
#import "TDHero.h"
#import "TDEnemy.h"
#import "TDEnemySmart.h"
#import "TDHUDLayer.h"
#import "SimpleAudioEngine.h"

@interface TDPlayfieldLayer : CCLayer {
    
    CGSize size;

    CCSpriteBatchNode *desertsheet;
    
    CCLayer *controls;
    TDHUDLayer *hudLayer;
    
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_ground;
    CCTMXLayer *_triggers;
    CCTMXLayer *_pickups;
    CCTMXLayer *_walls;
    CCTMXObjectGroup *spawns;
    
    NSInteger tmw; // tilemap width
    NSInteger tmh; // tilemap height
    NSInteger tw; // tile width
    NSInteger th; // tile height

    TDHero *hero;
    
    BOOL heroShooting;
    float shootSpeed;
    float currHeroShootSpeed;
    
    NSInteger heroKills;
    NSInteger heroGoalsRemaining;
    NSInteger heroHealth;
    
    NSMutableArray *enemyArray;
    NSMutableArray *bulletArray;
    
    BOOL isGameOver;
    BOOL preventTouches;
 
}

@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *ground;
@property (nonatomic, retain) CCTMXLayer *triggers;
@property (nonatomic, retain) CCTMXLayer *pickups;
@property (nonatomic, retain) CCTMXLayer *walls;

@property (nonatomic, retain) TDHero *hero;
@property (nonatomic, assign) BOOL heroShooting;
@property (nonatomic, assign) BOOL isGameOver;
@property (nonatomic, assign) BOOL preventTouches;

+(id) layerWithHUDLayer:(TDHUDLayer*)hud;

-(void) setHeroPos:(CGPoint)pos;
-(void) applyJoystick:(SneakyJoystick*)joystick toNode:(CCSprite*)sprite forTimeDelta:(float)delta;

-(CGPoint) getHeroPos;

-(void) rotateHeroToward:(CGPoint)target;

-(CGPoint) tileCoordForPos:(CGPoint)pos;
-(CGPoint) posForTileCoord:(CGPoint)tileCoord;

-(BOOL)isWallAtTileCoord:(CGPoint)tileCoord;

-(NSArray*) walkableAdjacentTilesCoordForTileCoord:(CGPoint)tileCoord;

-(void) addBullet:(TDBullet*)thisBullet;
-(void) removeBullet:(TDBullet*)thisBullet;

@end
