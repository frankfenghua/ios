//
//  BRGameHandler.mm
//  ch5-brick
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "BRGameHandler.h"

static BRGameHandler *gameHandler = nil;

@implementation BRGameHandler

@synthesize currentLevel;
@synthesize currentScore;
@synthesize currentLives;
@synthesize playfieldLayer;

#pragma mark Singleton methods
+ (id)sharedManager
{
    // Use Grand Central Dispatch to create it
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        gameHandler = [[super allocWithZone:NULL] init];
    });
    return gameHandler;
}

- (id)retain {
	return self;
}

- (unsigned)retainCount {	
	return NSUIntegerMax;
}

-(oneway void)release {
	//do nothing - the singleton is not allowed to release
}

- (id)autorelease {
	return self;
}

#pragma mark Initialization
-(id) init {
    if (self == [super init]) {
        [self resetGame];
	}
	return self;
}

-(void) resetGame {
    // Start with the defaults
    currentLevel = 1;
    currentLives = 3;
    currentScore = 0;
}

#pragma mark HUD Interactions
-(void) addToScore:(NSInteger)newPoints {
    currentScore = currentScore + newPoints;
}

-(void) loseLife {
    currentLives--;
}

#pragma mark Plist loaders
-(id) readPlist:(NSString*) fileName {
	NSData *plistData;
	NSString *error;
	NSPropertyListFormat format;
	id plist;
	
    // Assumes filename is part of the main bundle
	NSString *localizedPath = [[NSBundle mainBundle]
            pathForResource:fileName ofType:@"plist"];
	plistData = [NSData dataWithContentsOfFile:localizedPath];
	
	plist = [NSPropertyListSerialization
            propertyListFromData:plistData
            mutabilityOption:NSPropertyListImmutable
            format:&format errorDescription:&error];
	
	if (!plist) {
		NSLog(@"Error reading plist '%s', error '%s'",
        [localizedPath UTF8String], [error UTF8String]);
	}
	return plist;
}

-(NSDictionary*)getDictionaryFromPlist:(NSString*)fileName {
    return (NSDictionary*)[self readPlist:fileName];
}

@end
