//
//  PinchGestureController.h
//  Sample 08
//
//  Created by Lucas Jordan on 7/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameController.h"
#import "Saucer.h"

@interface PinchGestureController : GameController{
    Saucer* saucer;
    float startRadius;
}
-(void)pinchGesture:(UIPinchGestureRecognizer*)sender;
@end
