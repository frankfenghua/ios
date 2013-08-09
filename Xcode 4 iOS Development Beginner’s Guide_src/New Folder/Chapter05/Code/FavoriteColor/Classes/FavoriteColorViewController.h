//
//  FavoriteColorViewController.h
//  FavoriteColor
//
//  Created by GENIESOFT-MACBOOK on 19/12/10.
//  Copyright 2010 GENIESOFT STUDIOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteColorViewController : UIViewController {

    UITextField *txtColor;
    IBOutlet UILabel *lblColor;
}

@property (nonatomic, retain) IBOutlet UITextField *txtColor;
@property (nonatomic, retain) IBOutlet UILabel *lblColor;
@end
