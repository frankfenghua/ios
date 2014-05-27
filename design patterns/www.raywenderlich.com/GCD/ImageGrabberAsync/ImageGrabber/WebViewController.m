//
//  WebViewController.m
//  ImageGrabber
//
//  Created by Ray Wenderlich on 7/3/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import "WebViewController.h"
#import "ImageListViewController.h"

@implementation WebViewController
@synthesize toolbar;
@synthesize webView;
@synthesize imageListViewController;
@synthesize grabButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [toolbar release];
    [webView release];
    [imageListViewController release];
    [grabButton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    [imageListViewController release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Image Grabber";
    NSURL *url = [NSURL URLWithString:@"http://www.vickiwenderlich.com/2011/06/game-art-pack-monkey-platformer/"];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    grabButton.enabled = NO;
}

- (void)viewDidUnload
{
    [self setToolbar:nil];
    [self setWebView:nil];
    [self setGrabButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    numLoads++;
    grabButton.enabled = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    numLoads--;
    if (numLoads > 0) {
        grabButton.enabled = YES;
    }
}

- (IBAction)grabTapped:(id)sender {
    
    // Get HTML from web view
    NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
            
    // Hand HTML to list view for retrieval and display
    if (imageListViewController == nil) {
        imageListViewController = [[ImageListViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
    }
    imageListViewController.html = html;
    [self.navigationController pushViewController:imageListViewController animated:YES]; 
    
}
@end
