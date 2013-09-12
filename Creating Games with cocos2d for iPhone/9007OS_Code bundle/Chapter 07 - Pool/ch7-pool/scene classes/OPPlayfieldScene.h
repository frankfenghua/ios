//
//  OPPlayfieldScene.h
//  ch7-pool
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "OPDefinitions.h"

@interface OPPlayfieldScene : CCScene {
}

+(id) gameWithControl:(NSString*)controls andRules:(NSString*)gameRules;

@end
