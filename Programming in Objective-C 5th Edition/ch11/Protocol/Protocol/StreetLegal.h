//
//  StreetLegal.h
//  Protocol
//
//  Created by fenghua on 2013-08-16.
//  Copyright (c) 2013 fenghua. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StreetLegal <NSObject>
- (void)signalStop;
- (void)signalLeftTurn;
- (void)signalRightTurn;
@end
