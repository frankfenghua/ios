//
//  RotationGestureController.h
//  Sample 08
//
//  Created by Lucas Jordan on 8/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameController.h"
#import "Viper.h"

@interface RotationGestureController : GameController{
    Viper* viper;
    float startRotation;
}
-(void)rotationGesture:(UIRotationGestureRecognizer*)rotationRecognizer;
@end
