//
//  AccelerometerController.h
//  Sample 08
//
//  Created by Lucas Jordan on 8/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameController.h"
#import "Viper.h"

@interface AccelerometerController : GameController<UIAccelerometerDelegate>{
    Viper* viper;
}
@end
