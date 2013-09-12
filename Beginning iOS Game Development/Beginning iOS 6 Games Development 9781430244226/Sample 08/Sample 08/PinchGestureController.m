//
//  PinchGestureController.m
//  Sample 08
//
//  Created by Lucas Jordan on 7/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PinchGestureController.h"


@implementation PinchGestureController

-(BOOL)doSetup{
    if ([super doSetup]){
        [self setGameAreaSize:CGSizeMake(320, 480)];
        
        saucer = [Saucer saucer:self];
        [self addActor:saucer];
        
        UIPinchGestureRecognizer* pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
        [actorsView addGestureRecognizer:pinchRecognizer];
        
        return YES;
    }
    return NO;
}

-(void)pinchGesture:(UIPinchGestureRecognizer*)pinchRecognizer{
    if (pinchRecognizer.state == UIGestureRecognizerStateBegan){
        startRadius = [saucer radius];
        [saucer setAnimationPaused:YES];
    } else if (pinchRecognizer.state == UIGestureRecognizerStateChanged){
        float scale = [pinchRecognizer scale];
        float velocity =  [pinchRecognizer velocity];
        
        NSLog(@"Scale: %f Velocty: %f",scale, velocity);
        
        float radius = startRadius*scale;
        if (radius < 8){
            radius =  8;
        } else if (radius > 128.0){
            radius = 128;
        }
        
        [saucer setRadius:radius];
    } else if (pinchRecognizer.state == UIGestureRecognizerStateEnded){
        [saucer setAnimationPaused:NO];
    } else if (pinchRecognizer.state == UIGestureRecognizerStateCancelled){
        [saucer setRadius:startRadius];
        [saucer setAnimationPaused:NO];
    }
}

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self doSetup];
    // Do any additional setup after loading the view from its nib.
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
