//
//  SNSnake.h
//  ch4-snake
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SNSnakeSegment.h"

@class SNPlayfieldLayer;

@interface SNSnake : CCNode {
    
    SNPlayfieldLayer *parentLayer; // Parent layer
    
    NSMutableArray *snakebody; // Contains the snake
    
    NSInteger headRow; // Starting row for snake head
    NSInteger headColumn; // Starting col for snake head
    
    SnakeHeading _snakeDirection;  // Direction facing
    float _snakeSpeed; // Current rate of movement
}

@property (nonatomic, retain) NSMutableArray *snakebody;
@property (nonatomic, assign) SnakeHeading snakeDirection;
@property (nonatomic, assign) float snakeSpeed;

+(id) createWithLayer:(SNPlayfieldLayer*)myLayer
           withLength:(NSInteger)startLength;

-(void) addSegment;
-(void) move;
-(void) turnLeft;
-(void) turnRight;
-(void) deathFlash;

@end
