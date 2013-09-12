//
//  TouchEventsView.h
//  Sample 08
//
//  Created by Lucas Jordan on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchEventsController.h"

@interface TouchEventsView : UIView{
    IBOutlet TouchEventsController* controller;
    NSMutableArray* sparks;
}
    
@end
