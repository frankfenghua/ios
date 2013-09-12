//
//  Viper02.h
//  Sample 05
//
//  Created by Lucas Jordan on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Actor02.h"

@class Example02Controller;
@interface Viper02 : Actor02 {
    
}
@property CGPoint moveToPoint;

+(id)viper:(Example02Controller*)controller;
-(void)doCollision:(Actor02*)actor In:(Example02Controller*)controller;
@end
