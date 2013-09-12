//
//  Highscores.m
//  Sample 03
//
//  Created by Lucas Jordan on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Highscores.h"

@implementation Highscores
@synthesize theScores;

-(id)initWithDefaults{
    self = [super init];
    if (self != nil){
        theScores = [NSMutableArray new];
        for (int i=0;i<10;i++){
            [self addScore:[Score score:1 At:[NSDate date]]];
        }
    }
    return self;
}
-(void)addScore:(Score*)newScore{
    [theScores addObject:newScore];
    [theScores sortUsingSelector:@selector(compare:)];
    
    while ([theScores count] > 10){
        [theScores removeObjectAtIndex:10];
    }
}

- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:theScores forKey:@"theScores"];
}
- (id)initWithCoder:(NSCoder *)decoder{
    theScores = [[decoder decodeObjectForKey:@"theScores"] retain];
    return self;
}
-(void)dealloc{
    for (Score* score in theScores){
        [score release];
    }
    [theScores release];
    [super dealloc];
}
@end
