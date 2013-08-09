//
//  MusicPlayerViewController.m
//  MusicPlayer
//
//  Created by Steven F Daniel on 1/12/10.
//  Copyright 2010 GenieSoft Studios. All rights reserved.
//


#import "MusicPlayerViewController.h"

@implementation MusicPlayerViewController
@synthesize player;


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

- (IBAction)playAudio:(id)sender {
    
    // Get the file path to the song 
    NSString *filePath =[[NSBundle mainBundle] pathForResource:@"music" ofType:@"mp3"];
    
    // Convert the file path to a URL
    NSURL *fileUrl = [[NSURL alloc]initFileURLWithPath:filePath];
    
    //Initialize the AVAudioPlayer
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
    
    // Release the memory allocated to our objects  
	[filePath release];
    [fileUrl release];
    
    // Play the audio file   
	[self.player play];
}

- (IBAction)stopAudio:(id)sender {
    [self.player stop];
    
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
