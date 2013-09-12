//
//  LongPressController.m
//  Sample 08
//
//  Created by Lucas Jordan on 8/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LongPressController.h"
#import "Bullet.h"

@implementation LongPressController

-(BOOL)doSetup{
    if ([super doSetup]){
        [self setGameAreaSize:CGSizeMake(320, 480)];
        
        viper = [Viper viper:self];
        [self addActor:viper];
        
        CGPoint center = [viper center];
        center.y = [self gameAreaSize].height/5.0*4.0;
        [viper setCenter:center];
        
        
        UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        
        [actorsView addGestureRecognizer:tapRecognizer];

        UILongPressGestureRecognizer* longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
        [longPressRecognizer setMinimumPressDuration:1.0f];
        
        [actorsView addGestureRecognizer: longPressRecognizer];
        
        return YES;
    }
    return NO;
}

-(void)tapGesture:(UITapGestureRecognizer*)tapRecognizer{
    [self fireBulletAt:[tapRecognizer locationInView:actorsView] WithDamage:10];
}

-(void)longPressGesture:(UILongPressGestureRecognizer*)longPressRecognizer{
    
    if ([longPressRecognizer state] == UIGestureRecognizerStateBegan){
        [viper setState:VPR_STATE_TRAVELING];
        longStart = [NSDate date];
        
    } else if ([longPressRecognizer state] == UIGestureRecognizerStateEnded){
        
        NSDate* now = [NSDate date];
        
        float damage = 20;
        if ([now timeIntervalSinceDate:longStart] > 1.0f){
            damage = 30;
        }
        
        [self fireBulletAt:[longPressRecognizer locationInView:actorsView] WithDamage:damage];
        [viper setState:VPR_STATE_STOPPED];
    }
}
-(void)fireBulletAt:(CGPoint)point WithDamage:(float)damage{
    Bullet* bullet = [Bullet bulletAt:[viper center] TowardPoint:point];
    [bullet setDamage:damage];
    [self addActor:bullet];
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
