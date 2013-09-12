//
//  ViewController.m
//  Sample 11
//
//  Created by Lucas Jordan on 8/29/12.
//  Copyright (c) 2012 Lucas Jordan. All rights reserved.
//

#import "ViewController.h"
#import "Actor.h"
#import "Powerup.h"

@interface ViewController ()

@end

@implementation ViewController

-(BOOL)doSetup{
    if ([super doSetup]){
        [self setGameAreaSize:CGSizeMake(480, 320)];
        [self setIsPaused: NO];
        
        NSMutableArray* classes = [NSMutableArray new];
        [classes addObject:[Powerup class]];
        [self setSortedActorClasses:classes];

        viper = [Viper viper:self];
        [self addActor: viper];

        [self prepareAudio: AUDIO_POWERUP_BLINK];
        [self prepareAudio: AUDIO_GOT_POWERUP];
        [self playBackgroundAudio: AUDIO_BC_THEME];
        
        return YES;
    }
    return NO;
}

-(void)applyGameLogic{
    if (self.stepNumber%120==0){
        [self addActor:[Powerup powerup:self]];
    }
    for (Powerup* powerup in [self actorsOfType: [Powerup class]]){
        if ([powerup overlapsWith:viper]){
            [self removeActor: powerup];
            [self playAudio: AUDIO_GOT_POWERUP];
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self doSetup];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

- (IBAction)sitchValueChanged:(id)sender {
    UISwitch* theSwitch = (UISwitch*)sender;
    [self setAlwaysPlayAudioEffects: [theSwitch isOn]];
}
@end
