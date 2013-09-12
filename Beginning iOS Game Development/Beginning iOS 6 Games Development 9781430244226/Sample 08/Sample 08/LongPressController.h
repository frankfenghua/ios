//
//  LongPressController.h
//  Sample 08
//
//  Created by Lucas Jordan on 8/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameController.h"
#import "Viper.h"

@interface LongPressController : GameController{
    Viper* viper;
    NSDate* longStart;
}
-(void)tapGesture:(UITapGestureRecognizer*)tapRecognizer;
-(void)longPressGesture:(UILongPressGestureRecognizer*)longPressRecognizer;
-(void)fireBulletAt:(CGPoint)point WithDamage:(float)bulletSize;
@end
