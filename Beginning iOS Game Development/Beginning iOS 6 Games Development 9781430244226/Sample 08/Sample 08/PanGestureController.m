//
//  PanGestureController.m
//  Sample 08
//
//  Created by Lucas Jordan on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PanGestureController.h"
#import "Asteroid.h"

@implementation PanGestureController
@synthesize minYValue;
@synthesize maxYValue;

-(BOOL)doSetup{
    if ([super doSetup]){
        [self setGameAreaSize:CGSizeMake(320, 480)];
        [self setMinYValue:72.0f];
        [self setMaxYValue:480-[self minYValue]];
        
        asteroids = [NSMutableArray new];
        
        for (int i=0;i<3;i++){
            Asteroid* asteroid = [Asteroid asteroid:self];
            [[asteroid behaviors] removeAllObjects];
            
            [self addActor:asteroid];
            [asteroids addObject:asteroid];
            
            CGPoint center = CGPointMake(i*320.0/3.0+320.0/6.0, [self minYValue]);
            [asteroid setCenter:center];
        }
        
        UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [panRecognizer setMinimumNumberOfTouches:1];
        [actorsView addGestureRecognizer:panRecognizer];
        return YES;
    }
    return NO;
}

-(void)panGesture:(UIPanGestureRecognizer*)panRecognizer{
    
    if ([panRecognizer state] == UIGestureRecognizerStateBegan){
        CGSize gameAreaSize = [self gameAreaSize];
        CGPoint locationInView =  [panRecognizer locationInView:actorsView];
        
        if (locationInView.x < gameAreaSize.width/3.0){
            asteroidIndex = 0;
        } else if (locationInView.x > gameAreaSize.width/3.0*2){
            asteroidIndex = 2;
        } else {
            asteroidIndex = 1;
        }
        
        Asteroid* asteroid = [asteroids objectAtIndex:asteroidIndex];
        startCenter = [asteroid center];
        [asteroid setAnimationPaused:YES];
    } else if ([panRecognizer state] == UIGestureRecognizerStateChanged){
        Asteroid* asteroid = [asteroids objectAtIndex:asteroidIndex];
        CGPoint locationInView =  [panRecognizer locationInView:actorsView];
        
        CGPoint center = [asteroid center];
        center.y = locationInView.y;
        
        if (center.y < [self minYValue]){
            center.y = [self minYValue];
        }
        if (center.y > [self maxYValue]){
            center.y = [self maxYValue];
        }
        
        [asteroid setCenter:center];
    } else if ([panRecognizer state] == UIGestureRecognizerStateEnded){
        Asteroid* asteroid = [asteroids objectAtIndex:asteroidIndex];
        [asteroid setAnimationPaused:NO];
    } else if ([panRecognizer state] == UIGestureRecognizerStateCancelled){
        Asteroid* asteroid = [asteroids objectAtIndex:asteroidIndex];
        [asteroid setAnimationPaused:NO];
        [asteroid setCenter:startCenter];
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
