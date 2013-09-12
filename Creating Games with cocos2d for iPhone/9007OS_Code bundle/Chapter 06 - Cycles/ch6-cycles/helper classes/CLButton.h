//
//  CLButton.h
//  ch6-cycles
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CLDefinitions.h"
#import "CLBike.h"

@interface CLButton : CCSprite <CCTargetedTouchDelegate> {
    
    BOOL isLeft; // Is this a left turn button?

    CLBike *parentBike; // Bike the button controls
    
    CLPlayfieldLayer *myPlayfield; // main game layer
}

+(id) buttonForBike:(CLBike*)thisBike
         asPlayerNo:(NSInteger)playerNo
             isLeft:(BOOL)isLeftButton
            onLayer:(CLPlayfieldLayer*)thisLayer;

@end
