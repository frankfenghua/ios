//
//  HighscoreController.h
//  Sample 03
//
//  Created by Lucas Jordan on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define KEY_HIGHSCORES @"KEY_HIGHSCORES"

#import <UIKit/UIKit.h>
#import "Highscores.h"
#import "Score.h"

@interface HighscoreController : UIViewController {
    
    IBOutlet UIView* highscoresView;
    Highscores* highscores;
}
-(void)saveHighscores;
-(void)layoutScores:(Score*)latestScore;
-(void)addScore:(Score*)newScore;

@end
