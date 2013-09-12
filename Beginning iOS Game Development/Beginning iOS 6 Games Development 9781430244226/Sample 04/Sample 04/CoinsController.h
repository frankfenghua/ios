//
//  CoinsController.h
//  Sample 04
//
//  Created by Lucas Jordan on 4/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoinsGame.h"

@class CoinsController;
@protocol CoinsControllerDelegate <NSObject>

-(void)gameDidStart:(CoinsController*)aCoinsController with:(CoinsGame*)game;
-(void)scoreIncreases:(CoinsController*)aCoinsController with:(int)newScore;
-(void)turnsRemainingDecreased:(CoinsController*)aCoinsController with:(int)turnsRemaining;
-(void)gameOver:(CoinsController*)aCoinsController with:(CoinsGame*)game;

@end

@interface CoinsController : UIViewController {
    CoinsGame* coinsGame;
    UIView* coinsView;
    
    NSMutableArray* imageSequences;
    
    BOOL isFirstCoinSelected;
    Coord firstSelectedCoin;
    Coord secondSelectedCoin;
    BOOL acceptingInput;
    
    UIImageView* coinViewA;
    UIImageView* coinViewB;
    NSMutableArray* matchingRows;
    NSMutableArray* matchingCols;
    
    IBOutlet id<CoinsControllerDelegate> delegate;
}
@property (nonatomic, retain) CoinsGame* coinsGame;
@property (nonatomic, retain) id<CoinsControllerDelegate> delegate;

+(NSArray*)fillImageArray:(int)coin;

-(void)loadImages;
-(void)newGame;
-(void)continueGame:(CoinsGame*)aCoinsGame;
-(void)createAndLayoutImages;
-(void)tapGesture:(UIGestureRecognizer *)gestureRecognizer;
-(Coord)coordFromLocation:(CGPoint) location;
-(void)doSwitch:(Coord)coordA With:(Coord)coordB;
-(void)checkMatches;
-(void)updateCoinViews;

-(void)spinCoinAt:(Coord)coord;
-(void)stopCoinAt:(Coord)coord;

-(void)doEndGame;

@end

