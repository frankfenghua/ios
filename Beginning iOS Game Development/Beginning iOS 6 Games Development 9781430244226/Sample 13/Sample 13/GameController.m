//
//  GameController.m
//  Sample 06
//
//  Created by Lucas Jordan on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameController.h"
#import "Particle.h"
#import <QuartzCore/CATransaction.h>

@implementation GameController
@synthesize gameAreaSize;
@synthesize stepNumber;
@synthesize isSetup;
@synthesize isPaused;
@synthesize sortedActorClasses;
@synthesize score;
@synthesize scoreChangedOnStep;


-(BOOL)doSetup
{
    if (!isSetup){

        gameAreaSize = CGSizeMake(1024, 768);
        
        actors = [NSMutableSet new];
        
        actorsToBeAdded = [NSMutableSet new];
        actorsToBeRemoved = [NSMutableSet new];

        stepNumber = 0;
        
        workComplete = true;
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkCalled)];
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [displayLink setFrameInterval:1];
        isSetup = YES;
        
        score = 0;
        particleCount = 0;
        return YES;
    }
    return NO;
}
-(void)displayLinkCalled{
  if (workComplete && !isPaused){
        workComplete = false;
      @try {
          [self updateScene];
          workComplete = true;
      }
      @catch (NSException *exception) {
          NSLog(@"%@", [exception reason]);
          NSLog(@"%@", [exception userInfo]);//break point here
      }
    }
}
-(void)setSortedActorClasses:(NSMutableArray *)aSortedActorClasses{
    [sortedActorClasses removeAllObjects];
    sortedActorClasses = aSortedActorClasses;
    
    [actorClassToActorSet removeAllObjects];
    actorClassToActorSet = [NSMutableDictionary new];
    
    for (Class clazz in sortedActorClasses){
        [actorClassToActorSet setValue: [NSMutableSet new] forKey:[clazz description]];
    }
    
    for (Actor* actor in actors){
        NSMutableSet* sorted = [actorClassToActorSet objectForKey:[[actor class] description]];
        [sorted addObject:actor];
    }
    
}
-(NSMutableSet*)actorsOfType:(Class)clazz{
    return [actorClassToActorSet valueForKey:[clazz description]];
}

-(void)addActor:(Actor*)actor{
    if ([actor isKindOfClass:[Particle class]]){
        if (particleCount <= MAX_PARTICLES){
            particleCount++;
            [actor setAdded:YES];
            [actorsToBeAdded addObject:actor];
        } else {
            [actor setAdded:NO];
        }
    } else {
        [actor setAdded:YES];
        [actorsToBeAdded addObject:actor];
    }
}
-(void)removeActor:(Actor*)actor{
    if ([actor isKindOfClass:[Particle class]]){
        particleCount--;
    }
    [actor setRemoved:YES];
    [actorsToBeRemoved addObject:actor];
}
-(void)removeActors:(NSArray*)theActors{
    [actorsToBeRemoved addObjectsFromArray:theActors];
}

-(void)doAddActors{
    for (Actor* actor in actorsToBeAdded){
        [actors addObject:actor];
        
        UIView* view = [[actor representation] getViewForActor:actor In:self];
        [view setFrame:CGRectMake(0, 0, 0, 0)];
        [actorsView addSubview:view];
        
        NSMutableSet* sorted = [actorClassToActorSet valueForKey:[[actor class] description]];
        [sorted addObject:actor];
    }
    [actorsToBeAdded removeAllObjects];
}
-(void)doRemoveActors{
    for (Actor* actor in actorsToBeRemoved){
        
        UIView* view = [[actor representation] getViewForActor:actor In:self];
        [view removeFromSuperview];
        
        NSMutableSet* sorted = [actorClassToActorSet valueForKey:[[actor class] description]];
        [sorted removeObject:actor];
        
        [actors removeObject:actor]; 
    }
    [actorsToBeRemoved removeAllObjects];
}
-(void)updateScene{
    for (Actor* actor in actors){
        [actor step:self];
    }
    for (Actor* actor in actors){
        for (NSObject<Behavior>* behavoir in [actor behaviors]){
            [behavoir applyToActor:actor In:self];
        }
    }
    if (stepNumber%2 == 0){
    for (Actor* actor in actors){
        [self updateViewForActor:actor];
    }
    }
    
    [self applyGameLogic];
    
    [self doAddActors];
    [self doRemoveActors];
    stepNumber++;
}
-(void)applyGameLogic{
    //subclasses implement here
}
-(void)updateViewForActor:(Actor*)actor{
    NSObject<Representation>* rep = [actor representation];
    
    UIView* actorView = [rep getViewForActor:actor In:self];
    [rep updateView:actorView ForActor:actor In:self];
    
    float xFactor = actorsView.frame.size.width/self.gameAreaSize.width;
    float yFactor = actorsView.frame.size.height/self.gameAreaSize.height;
    
    float x = (actor.center.x-actor.radius)*xFactor;
    float y = (actor.center.y-actor.radius)*yFactor;
    float width = actor.radius*xFactor*2;
    float height = actor.radius*yFactor*2;
    CGRect frame = CGRectMake(x, y, width, height);
    
    actorView.transform = CGAffineTransformIdentity;
    [actorView setFrame:frame];
    actorView.transform = CGAffineTransformRotate(actorView.transform, [actor rotation]);	
    
    [actorView setAlpha:[actor alpha]];
}
-(void)removeAllActors{
    [self removeActors:[actors allObjects]];
    if (isPaused){
        [self doRemoveActors];
    }
}

-(void)incrementScore:(long)amount{
    score += amount;
    scoreChangedOnStep = stepNumber;
}
-(void)decrementScore:(long)amount{
    score -= amount;
    scoreChangedOnStep = stepNumber;
}



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
    [sortedActorClasses removeAllObjects];
    
    [actorClassToActorSet removeAllObjects];
    
    
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
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

@end
