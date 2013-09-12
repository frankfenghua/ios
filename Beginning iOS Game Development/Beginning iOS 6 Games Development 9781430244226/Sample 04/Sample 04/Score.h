//
//  Highscore.h
//  Sample 03
//
//  Created by Lucas Jordan on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Score : NSObject  <NSCoding>{
    NSDate* date;
    int score;
}
@property (nonatomic, retain) NSDate* date;
@property (nonatomic) int score;

+(id)score:(int)aScore At:(NSDate*)aDate;
@end
