//
//  Example03Controller.m
//  Sample 05
//
//  Created by Lucas Jordan on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Example03Controller.h"


@implementation Example03Controller
@synthesize gameAreaSize;
@synthesize stepNumber;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setGameAreaSize:CGSizeMake(160, 240)];
    actors = [NSMutableArray new];
    actorViews = [NSMutableDictionary new];
    toBeRemoved = [NSMutableArray new];
    
    Actor03* background = [[Actor03 alloc] initAt:CGPointMake(80, 120) WithRadius:120 AndImage:@"star_field_iphone"];
    [self addActor: background];
    
    viper = [Viper03 viper:self];
    [self addActor:viper];
    
    self.stepNumber = 0;
    
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer setNumberOfTouchesRequired:1];
    
    [actorView addGestureRecognizer:tapRecognizer];
    
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateScene)];
	[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
}
-(void)addActor:(Actor03*)actor{
    [actors addObject:actor];
}

-(void)removeActor:(Actor03*)actor{
    [toBeRemoved addObject:actor];
}
-(void)doRemove{
    for (Actor03* actor in toBeRemoved){
        UIImageView* imageView = [actorViews objectForKey:[actor actorId]];
        [actorViews removeObjectForKey:actor];
        
        [imageView removeFromSuperview];
        
        [actors removeObject:actor];
    }
    [toBeRemoved removeAllObjects];
}
-(void)updateScene{
    if (stepNumber % (60*5) == 0){
        [self addActor:[Asteroid03 asteroid:self]];
    }
    
    for (Actor03* actor in actors){
        [actor step:self];
    }
    
    for (Actor03* actor in actors){
        if ([actor isKindOfClass:[Asteroid03 class]]){
            if ([viper overlapsWith:actor]){
                [viper doCollision:actor In:self];
                break;
            }
        }
    }
    
    for (Actor03* actor in actors){
        [self updateActorView:actor];
    }
    [self doRemove];
    stepNumber++;
}


-(void)updateActorView:(Actor03*)actor{
    UIImageView* imageView = [actorViews objectForKey:[actor actorId]];
    
    if (imageView == nil){
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[actor imageName]]];
        [actorViews setObject:imageView forKey:[actor actorId]];
        [imageView setFrame:CGRectMake(0, 0, 0, 0)];
        [actorView addSubview:imageView];
    } else {
        if ([actor needsImageUpdated]){
            [imageView setImage:[UIImage imageNamed:[actor imageName]]];
        }
        
    }
    
    float xFactor = actorView.frame.size.width/self.gameAreaSize.width;
    float yFactor = actorView.frame.size.height/self.gameAreaSize.height;
    
    float x = (actor.center.x-actor.radius)*xFactor;
    float y = (actor.center.y-actor.radius)*yFactor;
    float width = actor.radius*xFactor*2;
    float height = actor.radius*yFactor*2;
    CGRect frame = CGRectMake(x, y, width, height);
    
    imageView.transform = CGAffineTransformIdentity;
    [imageView setFrame:frame];
    imageView.transform = CGAffineTransformRotate(imageView.transform, [actor rotation]);	
    
}

- (void)tapGesture:(UIGestureRecognizer *)gestureRecognizer{    
    UITapGestureRecognizer* tapRecognizer = (UITapGestureRecognizer*)gestureRecognizer;
    
    CGPoint pointOnView = [tapRecognizer locationInView:actorView];
    
    float xFactor = actorView.frame.size.width/self.gameAreaSize.width;
    float yFactor = actorView.frame.size.height/self.gameAreaSize.height;
    
    CGPoint pointInGame = CGPointMake(pointOnView.x/xFactor, pointOnView.y/yFactor);
    
    [viper setMoveToPoint:pointInGame];
    [viper setState:STATE_TURNING];
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
