//
//  MXMoleHill.h
//  ch3-moles
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MXMole.h"

@interface MXMoleHill : CCNode {

	NSInteger moleHillID;   //This identifies the number of the hill
    
	CCSprite *moleHillTop;
	CCSprite *moleHillBottom;
	NSInteger moleHillBaseZ;
    
	MXMole *hillMole;
    
	BOOL isOccupied;
}

@property (nonatomic, assign) NSInteger moleHillID;
@property (nonatomic, retain) CCSprite *moleHillTop;
@property (nonatomic, retain) CCSprite *moleHillBottom;
@property (nonatomic, assign) NSInteger moleHillBaseZ;
@property (nonatomic, retain) MXMole *hillMole;
@property (nonatomic, assign) BOOL isOccupied;

@end
