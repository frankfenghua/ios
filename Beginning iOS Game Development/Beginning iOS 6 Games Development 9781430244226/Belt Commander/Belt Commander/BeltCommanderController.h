//
//  BeltCommanderController.h
//  Belt Commander
//
//  Created by Lucas Jordan on 8/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameController.h"
#import "HealthBarView.h"
#import "Viper.h"
#import "GameParameters.h"

@class BeltCommanderDelegate, BeltCommanderController;

@protocol BeltCommanderDelegate
@required
-(void)gameStarted:(BeltCommanderController*)aBeltCommanderController;
-(void)gameOver:(BeltCommanderController*)aBeltCommanderController;
@end

@interface BeltCommanderController : GameController{
    IBOutlet HealthBarView* healthBarView;
    IBOutlet UILabel* scoreLabel;
    
    GameParameters* gameParameters;
    Viper* viper;
    
    //achievement tracking
    int asteroids_destroyed;
}

@property (nonatomic, retain) IBOutlet NSObject<BeltCommanderDelegate>* delegate;

-(void)doNewGame:(GameParameters*)aGameParameters;
-(void)tapGesture:(UITapGestureRecognizer*)tapRecognizer;

-(void)doEndGame;
-(void)doAddNewTrouble;
-(void)doCollisionDetection;
-(void)doUpdateHUD;
-(void)checkAchievements;

-(Viper*)viper;
@end
