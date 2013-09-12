//
//  ViewController.m
//  box2demo
//
//  Created by Kyle Oba on 11/5/11.
//  Copyright (c) 2011 Pas de Chocolat, LLC. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize displayLink;
@synthesize isInitialInterfaceOrientationSet;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.isInitialInterfaceOrientationSet = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return !isInitialInterfaceOrientationSet;
}

- (void)dealloc
{
    [self stopSimulation];
}


#pragma mark - Stuff I added

- (void)startSimulation
{
    self.isInitialInterfaceOrientationSet = YES;
    
    [self createPhysicsWorld];
    
	for (UIView *oneView in self.view.subviews)
	{
		[self addPhysicalBodyForView:oneView];
	}
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    //Configure and start accelerometer
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60.0)];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
}

- (void)stopSimulation
{
    if (!self.displayLink) return;
    [displayLink invalidate];
    self.displayLink = nil;
}


#pragma mark - Stuff from the original demo (slightly hacked)

- (void)createPhysicsWorld
{
	CGSize screenSize = self.view.bounds.size;
    
	// Define the gravity vector.
	b2Vec2 gravity;
	gravity.Set(0.0f, -9.81f);
    
	// Do we want to let bodies sleep?
	// This will speed up the physics simulation
	bool doSleep = false;
    
	// Construct a world object, which will hold and simulate the rigid bodies.
	world = new b2World(gravity);
    world->SetAllowSleeping(doSleep);
    
	world->SetContinuousPhysics(true);
    
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
    
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
    
	// Define the ground box shape.
	b2EdgeShape groundBox;
    
    CGSize worldSize = CGSizeMake(screenSize.width/PTM_RATIO,
                                  screenSize.height/PTM_RATIO);
    
	// bottom
	groundBox.Set(b2Vec2(0,0), b2Vec2(worldSize.width,0));
	groundBody->CreateFixture(&groundBox, 0);
    
	// top
	groundBox.Set(b2Vec2(0,worldSize.height), b2Vec2(worldSize.width,worldSize.height));
	groundBody->CreateFixture(&groundBox, 0);
    
	// left
	groundBox.Set(b2Vec2(0,worldSize.height), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox, 0);
    
	// right
	groundBox.Set(b2Vec2(worldSize.width,worldSize.height), b2Vec2(worldSize.width,0));
	groundBody->CreateFixture(&groundBox, 0);
}

- (void)addPhysicalBodyForView:(UIView *)physicalView
{
	// Define the dynamic body.
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    
	CGPoint p = physicalView.center;
    CGRect bounds = physicalView.frame;
	CGPoint boxDimensions = CGPointMake(bounds.size.width/PTM_RATIO/2.0,
                                        bounds.size.height/PTM_RATIO/2.0);
    
	bodyDef.position.Set(p.x/PTM_RATIO,
                         (CGRectGetHeight(self.view.bounds) - p.y)/PTM_RATIO);
	bodyDef.userData = (__bridge void *) physicalView;
    
	// Tell the physics world to create the body
	b2Body *body = world->CreateBody(&bodyDef);
    
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
    
	dynamicBox.SetAsBox(boxDimensions.x, boxDimensions.y);
    
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;
	fixtureDef.density = 3.0f;
	fixtureDef.friction = 0.3f;
	fixtureDef.restitution = 0.5f; // 0 is a lead ball, 1 is a super bouncy ball
	body->CreateFixture(&fixtureDef);
    
	// a dynamic body reacts to forces right away
	body->SetType(b2_dynamicBody);
    
	// we abuse the tag property as pointer to the physical body
	physicalView.tag = (int)body;
}

- (void)update:(CADisplayLink *)sender
{
    /*
     // Could do this if you had a timeRemaining (local) and lastTimestamp (property).
     if (lastTimestamp <= 0) lastTimestamp = sender.timestamp;
     CGFloat deltaTime = sender.timestamp - lastTimestamp;
     ti meRemaining -= deltaTime;
     lastTimestamp = sender.timestamp;
     */
    
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
    
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
    
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(1.0f/60.0f, velocityIterations, positionIterations);
    
	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL)
		{
			UIView *oneView = (__bridge UIView *)b->GetUserData();
            
			// y Position subtracted because of flipped coordinate system
			CGPoint newCenter = CGPointMake(b->GetPosition().x * PTM_RATIO,
                                            self.view.bounds.size.height - b->GetPosition().y * PTM_RATIO);
			oneView.center = newCenter;
            
			CGAffineTransform transform = CGAffineTransformMakeRotation(- b->GetAngle());
            
			oneView.transform = transform;
		}
	}
}


#pragma mark - Stuff from Accelerometer Bonus Section

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    CGPoint accel = CGPointMake(acceleration.x, acceleration.y);
    if ([self interfaceOrientation] == UIInterfaceOrientationPortraitUpsideDown) {
        accel.x *= -1.0f;
        accel.y *= -1.0f;
    } else if ([self interfaceOrientation] == UIInterfaceOrientationLandscapeLeft) {
        accel = CGPointMake(acceleration.y, -acceleration.x);
    } else if ([self interfaceOrientation] == UIInterfaceOrientationLandscapeRight) {
        accel = CGPointMake(-acceleration.y, acceleration.x);
    }
    
	b2Vec2 gravity;
	gravity.Set( accel.x * 9.81,  accel.y * 9.81 );
    
    
	world->SetGravity(gravity);
}


@end
