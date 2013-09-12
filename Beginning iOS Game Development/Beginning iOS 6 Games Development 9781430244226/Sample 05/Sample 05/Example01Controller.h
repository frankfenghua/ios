//
//  Example01Controller.h
//  Sample 05
//
//  Created by Lucas Jordan on 4/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CADisplayLink.h>
#import "Viper01.h"

@interface Example01Controller : UIViewController {
    CADisplayLink* displayLink;
    Viper01* viper;
}
-(void)updateScene;
-(void)viewTapped:(UIGestureRecognizer*)aGestureRecognizer;
@end
