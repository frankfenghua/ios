//
//  BRPlayfieldLayer.h
//  ch5-brick
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "BRDefinitions.h"
#import "BRGameHandler.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "BRContactListener.h"
#import "PhysicsSprite.h"

@interface BRPlayfieldLayer : CCLayer {
    CGSize size; // window size from CCDirector
    
    CCSpriteBatchNode *bricksheet; // The spritesheet
    
    BRGameHandler *gh; // Singleton class
    BRHUD *hudLayer; // A reference to the HUD layer
    
    ccTime stepTime; // Used in update for time elapsed
    
    NSInteger levelNum; // Current level number

    PhysicsSprite *paddle;
    
    BRContactListener *contactListener;

    b2World *world;
	b2Body *wallBody;
	b2Fixture *bottomGutter;    
    b2Body *paddleBody;
	b2Fixture *paddleFixture;
	b2MouseJoint *mouseJoint;
    
    ccTime paddleTimer;
    BOOL isPaddleDeformed;
    
    NSInteger multiballCounter;
    
    NSDictionary *patternDefs;
    
    CCLabelTTF *levelLabel;
    
    BOOL isGameOver;
    BOOL isBallInPlay;
    BOOL shouldStartMultiball;
}

@end
