//
//  GetUsersAttentionViewController.m
//  GetUsersAttention
//
//  Created by Steven F Daniel on 27/12/10.
//  Copyright 2010 GenieSoft Studios. All rights reserved.
//

#import "GetUsersAttentionViewController.h"
#import "AudioToolBox/AudioToolBox.h"

@implementation GetUsersAttentionViewController


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

// Plays an Alert Sound
- (IBAction)playAlertSound:(id)sender {
    SystemSoundID soundID;
    NSString *soundFile = [[NSBundle mainBundle]pathForResource:@"Teleport" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:soundFile],&soundID);
    AudioServicesPlaySystemSound(soundID);                                             
}

// Vibrates our iPhone
- (IBAction)vibratePhone:(id)sender {
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}

// Displays our Action Sheet 
- (IBAction)displayActionSheet:(id)sender {
    
    // Define an instance of our Action Sheet
    UIActionSheet *actionSheet; 
    
    // Initialise our Action Sheet with options
    actionSheet=[[UIActionSheet alloc]initWithTitle:@"Available Actions" delegate:self cancelButtonTitle:@"Cancel"
                             destructiveButtonTitle:@"Close" otherButtonTitles:@"Open File",@"Print",@"Email", nil];
    
    // Set our Action Sheet Style and then display it to our view
    actionSheet.actionSheetStyle=UIBarStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

// Delegate which handles the processing of the option buttons selected
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // String will be used to hold the text chosen for the button pressed.
    NSString *buttonText;  
    
    // Determine what button has been selected.
    switch (buttonIndex)
    {
        case 0: // We selected the Close button
            buttonText=@"You clicked on the 'Close' button"; 
            break;
        case 1: // We selected the Open File button
            buttonText=@"You clicked on the 'Open File' button";
            break;
        case 2: // We selected the Print button
            buttonText=@"You clicked on the 'Print' button";
            break;
        case 3: // We selected the Email button
            buttonText=@"You clicked on the 'Email' button";
            break;
        case 4: // We selected the Cancel button
            buttonText=@"You clicked on the 'Cancel' button";
            break;
		default: // Handle invalid button presses.
			buttonText=@"Invalid button pressed.";
    }

//    If we want to retrieve the selected button using it's text property, we would do so as follows.
//    
//    NSString *buttonTitle=[actionSheet buttonTitleAtIndex:buttonIndex];
//    if ([buttonTitle isEqualToString:@"Close"])
//    {
//       buttonText=@"You clicked on the 'Close' button";
//    }
//       
    // Initialise our Alert Window
    UIAlertView *dialog=[[UIAlertView alloc] initWithTitle:@"Alert Message" message:buttonText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
    
    // display our dialog and free the memory allocated by our dialog box
    [dialog show];
    [dialog release];
}

// Handles of the setting up and displaying of our Alert View Dialog
- (IBAction)displayAlertDialog:(id)sender {
    
    // Declare an instance of our Alert View dialog
    UIAlertView *dialog;
    
    // Initialise our Alert View Window with options
    dialog =[[UIAlertView alloc] initWithTitle:@"Alert Message" message:@"Have I got your attention" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    
    // display our dialog and free the memory allocated by our dialog box
    [dialog show];
    [dialog release];
}

// Responds to the options within our Alert View Dialog
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // String will be used to hold the text chosen for the button pressed.
    NSString *buttonText; 
    
    // Determine what button has been selected.
    switch (buttonIndex)
    {
        case 0: // User clicked on Cancel button
            buttonText=@"You clicked on the 'Cancel' button";
            break;
        case 1: // User clicked on the OK button
            buttonText=@"You clicked on the 'OK' button";
            break;
		default: // Handle invalid button presses.
			buttonText=@"Invalid button pressed.";
    }
        
    // If we want to retrieve the selected button using it's text property, we would do so as follows.
    //
    //    NSString *buttonTitle=[alertView buttonTitleAtIndex:buttonIndex];
    //    if ([buttonTitle isEqualToString:@"OK"])
    //    {
    //       buttonText=@"You clicked on the 'OK' button";
    //    }
    //         
    
    // Initialise our Alert Window
    UIAlertView *dialog=[[UIAlertView alloc] initWithTitle:@"Alert Message" message:buttonText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];

    // display our dialog and free the memory allocated by our dialog box
    [dialog show];
    [dialog release];  
}

// Displays our progress indicator with a message
- (IBAction)showProgress:(id)sender {

    // Initialise our Alert View window without any buttons
    baseAlert=[[[UIAlertView alloc]initWithTitle:@"Please wait,\ndownloading updates….." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil] autorelease];

    // Display our Progress Activity view
    [baseAlert show];
    
    // Create and add the UIActivity Indicator
    UIActivityIndicatorView *activityIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.center=CGPointMake(baseAlert.bounds.size.width / 2.0f,baseAlert.bounds.size.height-40.0f);

    // Initialise to tell our activity to start animating.
    [activityIndicator startAnimating];
    [baseAlert addSubview:activityIndicator];
    [activityIndicator release];
    
    // Automatically close our window after 3 seconds has passed.
    [self performSelector:@selector(showProgressDismiss) withObject:nil afterDelay:3.0f];
}

// Delegate to dismiss our Activity indicator after the number of seconds has passed.
- (void) showProgressDismiss
{
    [baseAlert dismissWithClickedButtonIndex:0 animated:NO];    
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}

@end