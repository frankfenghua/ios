//
//  Asteroid.h
//  Sample 06
//
//  Created by Lucas Jordan on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Actor.h"
#import "AsteroidRepresentationDelegate.h"
#import "GameController.h"

@interface Asteroid : Actor{
    
}
@property (nonatomic) int level;
+(id)asteroid:(GameController*)aController;
+(id)asteroidOfLevel:(int)aLevel At:(CGPoint)aCenter;
-(void)doHit:(GameController*)controller;
@end
