//
//  BRHUD.mm
//  ch5-brick
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "BRHUD.h"
#import "BRGameHandler.h"

@implementation BRHUD

-(id) init {
	
    if (self == [super init]) {
        
        // Load the spritesheet
        [[CCSpriteFrameCache sharedSpriteFrameCache]
            addSpriteFramesWithFile:@"bricksheet.plist"];
        bricksheet = [CCSpriteBatchNode
                    batchNodeWithFile:@"bricksheet.png"];
        
        // Add the batch node to the layer
        [self addChild:bricksheet z:1];
        
        // Get a reference to the Game Handler
        gh = [BRGameHandler sharedManager];
        
        // Instantiate the lives array
        livesArray = [[NSMutableArray alloc]
                                initWithCapacity:5];
        
        legendBox = [CCSprite spriteWithSpriteFrameName:
                     @"legend_box.png"];
        [legendBox setAnchorPoint:ccp(0.5,1)];
        [legendBox setPosition:ccp(160,480)];
        [self addChild:legendBox z:9];
        
        scoreTitle = [CCLabelTTF labelWithString:@"SCORE"
                    fontName:@"Alpha Echo" fontSize:20];
        [scoreTitle setPosition:ccp(260, 466)];
        [self addChild:scoreTitle z:10];
        
        // Get the current score
        NSString *currScore = [NSString stringWithFormat:
                    @"%i", [[BRGameHandler sharedManager]
                            currentScore]];
        
        scoreDisplay = [CCLabelTTF labelWithString:currScore
                    fontName:@"Alpha Echo" fontSize:20];
        [scoreDisplay setPosition:ccp(260, 446)];
        [self addChild:scoreDisplay z:10];
        
        livesTitle = [CCLabelTTF labelWithString:@"LIVES"
                    fontName:@"Alpha Echo" fontSize:20];
        [livesTitle setPosition:ccp(60, 466)];
        [self addChild:livesTitle z:10];
        
        [self createLifeImages];
    }
    return self;
}

-(void) dealloc {
    [livesArray removeAllObjects];
    [livesArray release];
    
    [super dealloc];
}

#pragma mark Score Display / Update
-(void) addToScore:(NSInteger)newPoints {
    // Update the score in the GameHandler
    [gh addToScore:newPoints];
    
    // Get a new string for the score display
    NSString *currScore = [NSString
            stringWithFormat:@"%i", [gh currentScore]];
    
    // Update the HUD
    [scoreDisplay setString:currScore];
}

#pragma mark Lives Display / Update
-(void) createLifeImages {
    for (int i = 1; i <= gh.currentLives; i++) {
        CCSprite *lifeToken = [CCSprite
                spriteWithSpriteFrameName:@"ball.png"];
        [lifeToken setPosition:ccp(20 + (20 * i), 446)];
        [self addChild:lifeToken z:10];
        [livesArray addObject:lifeToken];
    }
}

-(void) loseLife {
    // Remove a life from the GameHandler variable
    [gh loseLife];

    CCSprite *lifeToRemove = [livesArray lastObject];
    
    CCScaleBy *scaleLife = [CCScaleBy actionWithDuration:0.5
                                    scale:2.0];
    CCFadeOut *fadeLife = [CCFadeOut actionWithDuration:0.5];
    
    CCSpawn *scaleAndFade = [CCSpawn actionOne:scaleLife
                                    two:fadeLife];
    
    CCCallFuncND *destroyLife = [CCCallFuncND
                        actionWithTarget:self
                        selector:@selector(destroyLife:)
                        data:lifeToRemove];
    
    CCSequence *seq = [CCSequence actions:scaleAndFade,
                       destroyLife, nil];
    
    [lifeToRemove runAction:seq];
    
    [livesArray removeLastObject];
}

-(void) destroyLife:(CCSprite*)lifeToRemove {
    [lifeToRemove removeFromParentAndCleanup:YES];
}

@end
