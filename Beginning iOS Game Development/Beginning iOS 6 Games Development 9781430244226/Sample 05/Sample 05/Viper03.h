//
//  Viper03.h
//  Sample 05
//
//  Created by Lucas Jordan on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define STATE_STOPPED 0
#define STATE_TURNING 1
#define STATE_TRAVELING 2

#import <Foundation/Foundation.h>
#import "Actor03.h"

@interface Viper03 : Actor03 {
    
    
}
@property CGPoint moveToPoint;
@property int state;
@property BOOL clockwise;

+(id)viper:(Example03Controller*)controller;
-(void)doCollision:(Actor03*)actor In:(Example03Controller*)controller;
@end
