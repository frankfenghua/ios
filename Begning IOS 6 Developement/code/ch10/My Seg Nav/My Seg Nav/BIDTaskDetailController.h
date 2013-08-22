//
//  BIDTaskDetailController.h
//  My Seg Nav
//
//  Created by fenghua on 2013-08-22.
//  Copyright (c) 2013 fenghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BIDTaskDetailController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (copy, nonatomic) NSDictionary *selection;
@property (weak, nonatomic) id delegate;
@end
