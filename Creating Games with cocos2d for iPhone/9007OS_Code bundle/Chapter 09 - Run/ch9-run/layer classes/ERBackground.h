//
//  ERBackground.h
//  ch9-run
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ERBackground : CCLayer {
    
    CGSize size; // screen size
    
    CCSprite *bg1;
    CCSprite *bg2;
    
    float bgScrollSpeed;
    
    CGPoint initialOffset;
}

@property (nonatomic, assign) float bgScrollSpeed;
@property (nonatomic, assign) CGPoint initialOffset;

-(void) useDarkBG;
-(void) update:(ccTime)dt;

@end
