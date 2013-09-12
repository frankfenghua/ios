//
//  GameParameters.h
//  Belt Commander
//
//  Created by Lucas Jordan on 8/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#define GAME_PARAM_KEY @"GAME_PARAM_KEY"

#define PURCHASE_INGAME_SAUCERS @"com.beltcommander.ingame.saucers"
#define PURCHASE_INGAME_POWERUPS @"com.beltcommander.ingame.powerups"


#import <Foundation/Foundation.h>

@interface GameParameters : NSObject<NSCoding>

@property (nonatomic) BOOL includeAsteroids;
@property (nonatomic) BOOL includeSaucers;
@property (nonatomic) BOOL includePowerups;
@property (nonatomic, retain) NSMutableSet* purchases;

+(id)gameParameters;
+(id)readFromDefaults;
-(void)writeToDefaults;
@end
