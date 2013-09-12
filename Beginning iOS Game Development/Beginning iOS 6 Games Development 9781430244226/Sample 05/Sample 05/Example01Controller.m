//
//  Example01Controller.m
//  Sample 05
//
//  Created by Lucas Jordan on 4/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Example01Controller.h"


@implementation Example01Controller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Simple Movement"];
    
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    viper = [Viper01 new];
    
    CGRect frame = [self.view frame];
    
    viper.center = CGPointMake(frame.size.width/2.0, frame.size.height/2.0);
    [self.view addSubview:viper];
    [viper setMoveToPoint:viper.center];
    
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateScene)];
    
	[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}
-(void)viewTapped:(UIGestureRecognizer*)aGestureRecognizer{
    UITapGestureRecognizer* tapRecognizer = (UITapGestureRecognizer*)aGestureRecognizer;
    CGPoint tapPoint = [tapRecognizer locationInView:self.view];
    [viper setMoveToPoint: tapPoint];
}

-(void)updateScene{
    @try {
        [viper updateLocation];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    } 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
