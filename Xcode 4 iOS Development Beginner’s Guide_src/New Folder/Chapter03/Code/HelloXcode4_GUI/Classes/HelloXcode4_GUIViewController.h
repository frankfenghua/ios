//
//  HelloXcode4_GUIViewController.h
//  HelloXcode4_GUI
//
//  Created by Steven F Daniel on 13/11/10.
//  Copyright (c) 2010 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelloXcode4_GUIViewController : UIViewController {

    IBOutlet UITextField *txtUsername;
    IBOutlet UILabel *lblOutput;
}

-(IBAction)hideKeyboard:(id)sender;

@end
