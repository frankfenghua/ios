//
//  Example03Controller.m
//  Sample 06
//
//  Created by Lucas Jordan on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Example03Controller.h"
#import "Comet.h"
#import "Asteroid.h"

@implementation Example03Controller




-(BOOL)doSetup{
    if ([super doSetup]){
        NSMutableArray* classes = [NSMutableArray new];
        [classes addObject:[Asteroid class]];
        
        [self setSortedActorClasses:classes];
        
        UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [tapRecognizer setNumberOfTapsRequired:1];
        [tapRecognizer setNumberOfTouchesRequired:1];
        
        [actorsView addGestureRecognizer:tapRecognizer];
        
        return YES;
    }
    return NO;
}

-(void)updateScene{
    if (self.stepNumber % (60*5) == 0){
        [self addActor:[Comet comet:self]];
    }
    
    if ([[self actorsOfType:[Asteroid class]] count] == 0){
        int count = arc4random()%4+1;
        for (int i=0;i<count;i++){
            [self addActor:[Asteroid asteroid:self]];
        }
        
    }

    [super updateScene];
}

- (void)tapGesture:(UIGestureRecognizer *)gestureRecognizer{
    for (Asteroid* asteroid in [self actorsOfType:[Asteroid class]]){
        [asteroid doHit:self];
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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
