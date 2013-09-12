//
//  CLRenderGrid.h
//  ch6-cycles
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CLRenderGrid : CCLayer {
    
    CCRenderTexture *firstGrid; // We draw on this
    
    CCSprite *secondGrid; // Copy of the drawn grid

}

@end
