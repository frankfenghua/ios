//
//  SampleController.h
//  Sample 06
//
//  Created by Lucas Jordan on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Example01Controller.h"
#import "Example02Controller.h"
#import "Example03Controller.h"

@interface ExampleController : UIViewController {
    
    IBOutlet Example01Controller *example01Controller;
    IBOutlet Example02Controller *example02Controller;
    IBOutlet Example03Controller *example03Controller;
}
- (IBAction)example01ButtonTouched:(id)sender;
- (IBAction)example02ButtonTouched:(id)sender;
- (IBAction)example03ButtonTouched:(id)sender;

@end
