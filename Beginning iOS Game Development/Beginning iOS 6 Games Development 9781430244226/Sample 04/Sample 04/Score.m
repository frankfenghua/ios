//
//  Highscore.m
//  Sample 03
//
//  Created by Lucas Jordan on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Score.h"

@implementation Score
@synthesize date;
@synthesize score;

+(id)score:(int)aScore At:(NSDate*)aDate{
    Score* highscore = [[Score alloc] init];
    [highscore setScore:aScore];
    [highscore setDate:aDate];
    return highscore;
}
- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:date forKey:@"date"];
    [encoder encodeInt:score forKey:@"score"];
}
- (id)initWithCoder:(NSCoder *)decoder{
    date = [[decoder decodeObjectForKey:@"date"] retain];
    score = [decoder decodeIntForKey:@"score"];
    return self;
}
- (NSComparisonResult)compare:(id)otherObject {
    Score* otherScore = (Score*)otherObject;
    if (score > [otherScore score]){
        return NSOrderedAscending;
    } else if (score < [otherScore score]){
        return NSOrderedDescending;  
    } else {
        return NSOrderedSame;
    }
}
@end
