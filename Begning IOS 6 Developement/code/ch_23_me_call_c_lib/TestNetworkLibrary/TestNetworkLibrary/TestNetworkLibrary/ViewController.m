//
//  ViewController.m
//  TestNetLibTut
//
//  Created by Bartosz Czajkowski on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "NetworkInterface.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize textField;
@synthesize label;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setTextField:nil];
    [self setLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

int CallbackFunctionForNet(requestId p_Request, char *p_Data, int p_Bytes, errorCode p_Code , void* UserContext)
{
    NSLog(@"callback is working %d", p_Request);
    
    return 0;
}

- (IBAction)changeGreeting:(id)sender {
    NSLog(@"initializeNetworkSystem");
    errorCode initNetw = InitializeNetworkSystem();
    int gId = CreateGetRequest("http://www.wp.pl");
    //NetworkLibraryCallback tmpCallback;
    //int (*tmpCallback)(requestId p_Request, char *p_Data, int p_Bytes, errorCode p_Code);
    //tmpCallback = &CallbackFunctionForNet;
    RegisterCallback(gId, &CallbackFunctionForNet, NULL);
    int rId = CreatePostRequest("https://requestb.in/10fsvzz1", "DIE you stupid appppppppp", 18);
    RegisterCallback(rId, &CallbackFunctionForNet, NULL);
    StartConnection(rId);
    StartConnection(gId);
    //int rId2 = CreateSocketRequest("http://10.0.0.127:30000", "DIE APPLE DIE testtest", 16);
    NSLog(@"requests send");
    
    NSString *greeting = [[NSString alloc] initWithFormat:@"Hello, lol2! %d  -  %d  S %d", initNetw, rId, gId];
    self.label.text = greeting;
}
@end
