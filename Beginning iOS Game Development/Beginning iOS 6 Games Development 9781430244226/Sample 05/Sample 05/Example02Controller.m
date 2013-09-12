//
//  Example02Controller.m
//  Sample 05
//
//  Created by Lucas Jordan on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Example02Controller.h"


@implementation Example02Controller
@synthesize gameAreaSize;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setGameAreaSize:CGSizeMake(160, 240)];
    actors = [NSMutableArray new];
    actorViews = [NSMutableDictionary new];
    toBeRemoved = [NSMutableArray new];
    
    Actor02* background = [[Actor02 alloc] initAt:CGPointMake(80, 120) WithRadius:120 AndImage:@"star_field_iphone"];
    [self addActor: background];
    
    viper = [Viper02 viper:self];
   // [viper setMoveToPoint:viper.center];
    [self addActor:viper];
    
    stepNumber = 0;
    
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer setNumberOfTouchesRequired:1];
    
    [actorView addGestureRecognizer:tapRecognizer];
    
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateScene)];
	[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
}
-(void)addActor:(Actor02*)actor{
    [actors addObject:actor];
}

-(void)removeActor:(Actor02*)actor{
    [toBeRemoved addObject:actor];
}
-(void)doRemove{
    for (Actor02* actor in toBeRemoved){
        UIImageView* imageView = [actorViews objectForKey:[actor actorId]];
        [actorViews removeObjectForKey:actor];
        
        [imageView removeFromSuperview];
        
        [actors removeObject:actor];
    }
    [toBeRemoved removeAllObjects];
}
-(void)updateScene{
    if (stepNumber % (60*10) == 0){
        [self addActor:[Asteroid02 asteroid:self]];
    }
    
    for (Actor02* actor in actors){
        [actor step:self];
    }
    
    for (Actor02* actor in actors){
        if ([actor isKindOfClass:[Asteroid02 class]]){
            if ([viper overlapsWith:actor]){
                [viper doCollision:actor In:self];
                break;
            }
        }
    }
    
    for (Actor02* actor in actors){
        [self updateActorView:actor];
    }
    [self doRemove];
    stepNumber++;
}


-(void)updateActorView:(Actor02*)actor{
    UIImageView* imageView = [actorViews objectForKey:[actor actorId]];
    
    if (imageView == nil){
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[actor imageName]]];
        [actorViews setObject:imageView forKey:[actor actorId]];
        [imageView setFrame:CGRectMake(0, 0, 0, 0)];
        [actorView addSubview:imageView];
    }
    
    float xFactor = actorView.frame.size.width/self.gameAreaSize.width;
    float yFactor = actorView.frame.size.height/self.gameAreaSize.height;
    
    float x = (actor.center.x-actor.radius)*xFactor;
    float y = (actor.center.y-actor.radius)*yFactor;
    float width = actor.radius*xFactor*2;
    float height = actor.radius*yFactor*2;
    CGRect frame = CGRectMake(x, y, width, height);
    [imageView setFrame:frame];

}

- (void)tapGesture:(UIGestureRecognizer *)gestureRecognizer{    
    UITapGestureRecognizer* tapRecognizer = (UITapGestureRecognizer*)gestureRecognizer;
    
    CGPoint pointOnView = [tapRecognizer locationInView:actorView];
    
    float xFactor = actorView.frame.size.width/self.gameAreaSize.width;
    float yFactor = actorView.frame.size.height/self.gameAreaSize.height;
    
    CGPoint pointInGame = CGPointMake(pointOnView.x/xFactor, pointOnView.y/yFactor);
    
    [viper setMoveToPoint:pointInGame];
}

- (IBAction)sliderValueChanged:(id)sender {
    UISlider* slider = (UISlider*)sender;
    float newWidth = [slider value];
    float newHeight = gameAreaSize.height/gameAreaSize.width*newWidth;
      
    CGRect parentFrame = [[actorView superview] frame];
    float newX = (parentFrame.size.width-newWidth)/2.0;
    float newY = (parentFrame.size.height-newHeight)/2.0;
    
    CGRect newFrame = CGRectMake(newX, newY, newWidth, newHeight);
    [actorView setFrame:newFrame];
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


- (void)viewDidUnload
{
    actorView = nil;
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
