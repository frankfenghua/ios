//
//  BeltCommanderController.m
//  Belt Commander
//
//  Created by Lucas Jordan on 8/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BeltCommanderController.h"
#import "Asteroid.h"
#import "Bullet.h"
#import "Saucer.h"
#import "Powerup.h"
#import <GameKit/GameKit.h>
#import "Shield.h"

@implementation BeltCommanderController
@synthesize delegate;

-(BOOL)doSetup{
    if ([super doSetup]){
        [self setGameAreaSize:CGSizeMake(480, 320)];
        [self setIsPaused:YES];
        
        NSMutableArray* classes = [NSMutableArray new];
        [classes addObject:[Saucer class]];
        [classes addObject:[Bullet class]];
        [classes addObject:[Asteroid class]];
        [classes addObject:[Powerup class]];
        [self setSortedActorClasses:classes];
        
        UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        
        [actorsView addGestureRecognizer:tapRecognizer];
        
        [self prepareAudio: AUDIO_BLIP];
        [self prepareAudio: AUDIO_GOT_POWERUP];
        [self prepareAudio: AUDIO_VIPER_EXPLOSION];
        [self playBackgroundAudio: AUDIO_BC_THEME];
        
        return YES;
    }
    return NO;
}

-(void)doNewGame:(GameParameters*)aGameParameters{
    gameParameters = aGameParameters;
    
    [self removeAllActors];
    
    [self setScore:0];
    [self setStepNumber:0];
    [self setScoreChangedOnStep:0];
    
    viper = [Viper viper:self];
    [self addActor:viper];
    
    asteroids_destroyed = 0;
    
    [self setIsPaused:NO];
    [delegate gameStarted:self];
}

-(void)applyGameLogic{
    if ([viper health] <= 0.0f){
        [self playAudio:AUDIO_VIPER_EXPLOSION];
        [self doEndGame];
    } else {
        
        [self doAddNewTrouble];
        [self doCollisionDetection];
        [self doUpdateHUD];
        
        if ([self stepNumber]%30 == 0){
            [self checkAchievements];
        }
    }
}
-(void)checkAchievements{
    if (asteroids_destroyed >= 10){
        
        GKAchievement* achievement = [[GKAchievement alloc] initWithIdentifier:@"beltcommander.10asteroids"];
        achievement.percentComplete = 100.0;
        
        [achievement reportAchievementWithCompletionHandler:^(NSError *error) {
            if (error){
                // report error
            }
        }];
    } 
}
-(void)doEndGame{
    [self setIsPaused:YES];
    [delegate gameOver:self];
}
-(void)doAddNewTrouble{
    if ([gameParameters includeAsteroids] && arc4random() % (5*60) == 0){
        if ([[self actorsOfType:[Asteroid class]] count] < 20){
            [self addActor:[Asteroid asteroid:self]];
        }
    }
    if ([gameParameters includeSaucers] && arc4random() % (10*60) == 0){
        if ([[self actorsOfType:[Saucer class]] count] < 3){
            [self addActor:[Saucer saucer:self]];
        }
    }
    if ([gameParameters includePowerups] && arc4random() % (20*60) == 0){
        [self addActor:[Powerup powerup:self]];
    }
}

-(void)doCollisionDetection{
    NSSet* bullets = [self actorsOfType:[Bullet class]];
    NSSet* asteroids = [self actorsOfType:[Asteroid class]];
    NSSet* saucers = [self actorsOfType:[Saucer class]];
    NSSet* powerups = [self actorsOfType:[Powerup class]];
    
    for (Asteroid* asteroid in asteroids){
        for (Bullet* bullet in bullets){
            if ([bullet overlapsWith:asteroid]){
                [bullet decrementDamage: self];
                
                asteroids_destroyed++;
                [asteroid doHit:self];
                [self incrementScore: [asteroid level]*10];
                break;
            }
        }
        if ([asteroid overlapsWith:viper]){
            [viper decrementHealth: [asteroid level]*2];
            
            Shield* shield = [Shield shieldProtecting:viper From: asteroid];
            [self addActor:shield];
            
            asteroids_destroyed++;
            [asteroid doHit:self];
        }
    }
    
    for (Bullet* bullet in bullets){
        if ([[bullet source] isKindOfClass:[Saucer class]]){
            if ([viper overlapsWith: bullet]){
                [viper decrementHealth: [bullet damage]];
                
                Shield* shield = [Shield shieldProtecting:viper From: bullet];
                [self addActor:shield];
                
                [self removeActor:bullet];
                break;
            }
        } else {
            for (Saucer* saucer in saucers){
                if ([saucer overlapsWith: bullet]){
                    [saucer decrementHealth:[bullet damage]];
                    Shield* shield = [Shield shieldProtecting:saucer From:bullet];
                    [self addActor:shield];
                    [self removeActor:bullet];
                    break;
                }
            }
        }
    }
    
    for (Powerup* powerup in powerups){
        if ([powerup overlapsWith:viper]){
            [self playAudio:AUDIO_GOT_POWERUP];
            [powerup doHitOn:viper in:self];
        }
    }
}

-(void)doUpdateHUD{
    if ([self stepNumber] == [self scoreChangedOnStep]){
        [scoreLabel setText: [[NSNumber numberWithLong:[self score]] stringValue] ];
    }
    [healthBarView setHealth:[viper health]/[viper maxHealth]];
}

-(void)tapGesture:(UITapGestureRecognizer*)tapRecognizer{
    if (![self isPaused]){
        
        CGSize gameSize = [self gameAreaSize];
        CGSize viewSize = [actorsView frame].size;
        float xRatio = gameSize.width/viewSize.width;
        float yRatio = gameSize.height/viewSize.height;
        
        CGPoint locationInView = [tapRecognizer locationInView:actorsView];
        CGPoint pointInGame = CGPointMake(locationInView.x*xRatio, locationInView.y*yRatio);
        [viper setMoveToPoint: pointInGame within:self];
    }
}
-(Viper*)viper{
    return viper;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self doSetup];
}
- (IBAction)leaderBoardsClicked:(id)sender {
}
@end
