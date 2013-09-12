//
//  BRGameHandler.h
//  ch5-brick
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BRHUD.h"

@class BRPlayfieldLayer;

@interface BRGameHandler : CCNode {
	BRPlayfieldLayer *playfieldLayer;

	NSInteger currentLevel;
	NSInteger currentScore;
	NSInteger currentLives;

}
@property (nonatomic) NSInteger currentLevel;
@property (nonatomic) NSInteger currentScore;
@property (nonatomic) NSInteger currentLives;

@property (nonatomic, retain) BRPlayfieldLayer *playfieldLayer;

+(id)sharedManager;

-(void) resetGame;

-(void) addToScore:(NSInteger)newPoints;
-(void) loseLife;

-(NSDictionary*)getDictionaryFromPlist:(NSString*)fileName;

@end
