//
//  SwipeGestureController.m
//  Sample 08
//
//  Created by Lucas Jordan on 9/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SwipeGestureController.h"
#import "LinearMotion.h"
#import "Comet.h"

@implementation SwipeGestureController

-(BOOL)doSetup{
    if ([super doSetup]){
        [self setGameAreaSize:CGSizeMake(320, 480)];
        
        UISwipeGestureRecognizer* down = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
        [down setDirection:UISwipeGestureRecognizerDirectionDown];
        [actorsView addGestureRecognizer:down];
        
        UISwipeGestureRecognizer* up = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
        [up setDirection:UISwipeGestureRecognizerDirectionUp];
        [actorsView addGestureRecognizer:up];
        
        UISwipeGestureRecognizer* left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
        [left setDirection:UISwipeGestureRecognizerDirectionLeft];
        [actorsView addGestureRecognizer:left];
        
        UISwipeGestureRecognizer* right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
        [right setDirection:UISwipeGestureRecognizerDirectionRight];
        [actorsView addGestureRecognizer:right];
        
        return YES;
    }
    return NO;
}

-(void)swipeGesture:(UISwipeGestureRecognizer*)swipeRecognizer{
    CGSize gameSize = [self gameAreaSize];
    
    UISwipeGestureRecognizerDirection direction = [swipeRecognizer direction];
    CGPoint locationInView = [swipeRecognizer locationInView:actorsView];
    
    
    CGPoint center = CGPointMake(0, 0);
    float directionInRadians = DIRECTION_DOWN;
    
    if (direction == UISwipeGestureRecognizerDirectionRight){
        center.x = -20;
        center.y = locationInView.y;
        directionInRadians = DIRECTION_RIGHT;
    } else if (direction == UISwipeGestureRecognizerDirectionDown){
        center.x = locationInView.x;
        center.y = -20;
        directionInRadians = DIRECTION_DOWN;
    } else if (direction == UISwipeGestureRecognizerDirectionLeft){
        center.x = gameSize.width+20;
        center.y = locationInView.y;
        directionInRadians = DIRECTION_LEFT;
    } else if (direction == UISwipeGestureRecognizerDirectionUp){
        center.x = locationInView.x;
        center.y = gameSize.height+20;
        directionInRadians = DIRECTION_UP;
    }
    
    Comet* comet = [Comet comet:self withDirection:directionInRadians andCenter:center];
    [self addActor:comet];
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
