//
//  PhysicsViewController.m
//  Sample 13
//
//  Created by Lucas Jordan on 8/23/12.
//  Copyright (c) 2012 Lucas Jordan. All rights reserved.
//

#import "PhysicsViewController.h"
#import "Asteroid.h"

@interface PhysicsViewController ()

@end

@implementation PhysicsViewController

-(BOOL)doSetup{
    if ([super doSetup]){
        [self setGameAreaSize:CGSizeMake(1024, 768)];
        [self createPhysicsWorld];
        
        for (int i=0;i<30;i++){
            float startY = rand()%(int)self.gameAreaSize.height;
            float startX = rand()%(int)self.gameAreaSize.width;
            
            CGPoint center = CGPointMake(startX, startY);

            int level = 1 + rand()%4;
            
            Asteroid* asteroid = [Asteroid asteroidOfLevel:level At: center];
            [self addActor: asteroid];
        }
        
        return YES;
    }
    return NO;
}
-(void)applyGameLogic{
float32 timeStep = 1.0f / 60.0f;
    int32 velocityIterations = 6;
    
    int32 positionIterations = 2;
    world->Step(timeStep, velocityIterations, positionIterations);
    
}
- (void)createPhysicsWorld {
	b2Vec2 gravity;
	gravity.Set(0.0f, 0.0f);
    
	world = new b2World(gravity);
    world->SetAllowSleeping(false);
    world->SetContinuousPhysics(true);
}
-(void)addActor:(Actor *)actor{
    if ([actor isKindOfClass:[PhysicsActor class]]){
        PhysicsActor* physicsActor = (PhysicsActor*)actor;
        b2BodyDef bodyDef = [physicsActor createBodyDef];
        
        b2Body* body = world->CreateBody(&bodyDef);
        
        b2CircleShape circle;
        circle.m_p.Set(0.0f, 0.0f);
        circle.m_radius = [PhysicsViewController convertDistanceToB2:[actor radius]];
        
        b2FixtureDef fixtureDef;
        
        fixtureDef.shape = &circle;
        fixtureDef.density = [physicsActor radius];
        fixtureDef.friction = 0.1f;
        fixtureDef.restitution = .8;
        
        body->CreateFixture(&fixtureDef);
        [physicsActor setBody:body];
    }
    [super addActor:actor];
}
-(void)removeActor:(Actor *)actor{
    if ([actor isKindOfClass:[PhysicsActor class]]){
        PhysicsActor* physicsActor = (PhysicsActor*)actor;
        b2Body* body = [physicsActor body];
        world->DestroyBody(body);
    }
    [super removeActor:actor];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self doSetup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
+(CGPoint)convertPointToCG:(b2Vec2)position{
    return CGPointMake(position.x*10.0, position.y*10.0);
}
+(b2Vec2)convertPointToB2:(CGPoint)point{
    b2Vec2 pos;
    pos.x = point.x/10.0;
    pos.y = point.y/10.0;
    return pos;
}
+(float)convertDisntanceToGC:(float)distance{
    return distance*10.0;
}
+(float)convertDistanceToB2:(float)distance{
    return distance/10.0;
}
@end
