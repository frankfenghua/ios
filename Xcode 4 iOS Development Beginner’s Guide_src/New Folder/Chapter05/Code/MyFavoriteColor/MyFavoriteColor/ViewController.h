//
//  ViewController.h
//  MyFavoriteColor
//
//  Created by fenghua on 2013-08-12.
//  Copyright (c) 2013 fenghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    IBOutlet UITextField *txtColor;
    IBOutlet UILabel *lblColor;

}
@property (retain, nonatomic) IBOutlet UITextField *txtColor;
@property (retain, nonatomic) IBOutlet UILabel *lblColor;

@end
