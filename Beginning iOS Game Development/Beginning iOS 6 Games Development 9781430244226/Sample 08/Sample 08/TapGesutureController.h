//
//  TapGesutureController.h
//  Sample 08
//
//  Created by Lucas Jordan on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameController.h"
#import "Powerup.h"
#import "TemporaryBehavior.h"

@interface TapGesutureController : GameController<TemporaryBehaviorDelegate>{
    NSMutableArray* powerups;
}

- (void)tapGesture:(UITapGestureRecognizer *)sender;

@end
