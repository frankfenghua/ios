//
//  Bicycle.h
//  Protocol
//
//  Created by fenghua on 2013-08-16.
//  Copyright (c) 2013 fenghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StreetLegal.h"

@interface Bicycle : NSObject<StreetLegal>
- (void)startPedaling;
- (void)removeFrontWheel;
- (void)lockToStructure:(id)theStructure;
@end
