//
//  ViewController.h
//  Sample 11
//
//  Created by Lucas Jordan on 8/29/12.
//  Copyright (c) 2012 Lucas Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameController.h"
#import "Viper.h"


@interface ViewController : GameController{
    Viper* viper;
}
- (IBAction)sitchValueChanged:(id)sender;

@end
