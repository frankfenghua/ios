//
//  ERHUDLayer.h
//  ch9-run
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ERHUDLayer : CCLayer {

    CCLabelTTF *lblDistance;
}

-(void) changeDistanceTo:(float)newDistance;

-(void) showGameOver:(NSString*)msg;

@end
