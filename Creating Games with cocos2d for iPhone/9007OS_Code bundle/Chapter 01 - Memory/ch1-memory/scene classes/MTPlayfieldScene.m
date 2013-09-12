//
//  MTPlayfieldScene.m
//  ch1-memory
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "MTPlayfieldScene.h"

@implementation MTPlayfieldScene

+(id) sceneWithRows:(NSInteger)numRows
         andColumns:(NSInteger)numCols {
	return [[[self alloc] sceneWithRows:numRows
                             andColumns:numCols]
                                    autorelease];
}

-(id) sceneWithRows:(NSInteger)numRows
         andColumns:(NSInteger)numCols {
	
	if( (self=[super init])) {
        // Create an instance of the MTPlayfieldLayer
        MTPlayfieldLayer *layer = [MTPlayfieldLayer
                                   layerWithRows:numRows
                                   andColumns:numCols];
        [self addChild: layer];
	}
	return self;
}

@end
