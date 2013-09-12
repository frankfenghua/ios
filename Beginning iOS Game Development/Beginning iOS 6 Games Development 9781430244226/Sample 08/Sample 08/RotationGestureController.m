//
//  RotationGestureController.m
//  Sample 08
//
//  Created by Lucas Jordan on 8/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RotationGestureController.h"

@implementation RotationGestureController

-(BOOL)doSetup{
    if ([super doSetup]){
        [self setGameAreaSize:CGSizeMake(320, 480)];
        
        viper = [Viper viper:self];
        [self addActor:viper];
        
        UIRotationGestureRecognizer* rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGesture:)];

        [actorsView addGestureRecognizer:rotationRecognizer];
        return YES;
    }
    return NO;
}


-(void)rotationGesture:(UIRotationGestureRecognizer*)rotationRecognizer{
   
    if ([rotationRecognizer state] == UIGestureRecognizerStateBegan){
        startRotation = [viper rotation];
    } else if ([rotationRecognizer state] == UIGestureRecognizerStateChanged){
        
        float rotation = [rotationRecognizer rotation];
        float finalRotation = startRotation + rotation*2.0;

        if (finalRotation > [viper rotation]){
            [viper setState:VPR_STATE_CLOCKWISE];
        } else {
            [viper setState:VPR_STATE_COUNTER_CLOCKWISE];
        }
        
        [viper setRotation: finalRotation];
        
    } else if ([rotationRecognizer state] == UIGestureRecognizerStateEnded){
        [viper setState:VPR_STATE_STOPPED];
    } else if ([rotationRecognizer state] == UIGestureRecognizerStateCancelled){
        [viper setState:VPR_STATE_STOPPED];
        [viper setRotation:startRotation];
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
