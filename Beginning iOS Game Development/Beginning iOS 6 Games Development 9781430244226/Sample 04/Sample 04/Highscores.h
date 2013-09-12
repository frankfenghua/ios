//
//  Highscores.h
//  Sample 03
//
//  Created by Lucas Jordan on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Score.h"

@interface Highscores : NSObject <NSCoding>{
    NSMutableArray* theScores;
}
@property (nonatomic, retain) NSMutableArray* theScores;

-(id)initWithDefaults;
-(void)addScore:(Score*)newScore;

@end
