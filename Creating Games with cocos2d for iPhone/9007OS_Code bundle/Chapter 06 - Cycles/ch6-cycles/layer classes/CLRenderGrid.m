//
//  CLRenderGrid.m
//  ch6-cycles
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "CLRenderGrid.h"

@implementation CLRenderGrid

-(id) init {
    if(self = [super init]) {

        CGSize size = [[CCDirector sharedDirector] winSize];
    
        // create a blank render texture
        firstGrid = [[CCRenderTexture alloc] 
            initWithWidth:700 height:950 
            pixelFormat:kCCTexture2DPixelFormat_RGBA8888];

        // Draw the first grid in a render texture
        [self drawGrid];

        [[firstGrid sprite] setAnchorPoint:ccp(0.5,0.5)];
        [[firstGrid sprite] setPosition:ccp(size.width/2,
                                    size.height/2)];
        [[firstGrid sprite] setOpacity:50];
        
        // Override the default blend
        [[firstGrid sprite] setBlendFunc:
            (ccBlendFunc){GL_SRC_ALPHA,
             GL_ONE_MINUS_SRC_ALPHA}];
        
        [self addChild:firstGrid];
        
        // Second grid
        // Clone the grid as a separate sprite
        secondGrid = [CCSprite spriteWithTexture:
                      [[firstGrid sprite] texture]];
        [secondGrid setAnchorPoint:ccp(0.5,0.5)];
        [secondGrid setPosition:ccp(size.width/2,
                                    size.height/2)];
        [secondGrid setOpacity:60];
        [secondGrid setColor:ccWHITE];
        [self addChild:secondGrid];

        // Start grids moving
        [self moveFirstGrid];
        [self moveSecondGrid];


    }
    return self;
}

-(void) dealloc {
    [firstGrid release];

    [super dealloc];
}

-(void) visit {
    // We use the glScissor to clip the edges
    // So we can shift stuff around in here, but not
    // go outside our boundaries
    glEnable(GL_SCISSOR_TEST);
    glScissor(59 * CC_CONTENT_SCALE_FACTOR(),
              62 * CC_CONTENT_SCALE_FACTOR(),
              650 * CC_CONTENT_SCALE_FACTOR(),
              900 * CC_CONTENT_SCALE_FACTOR());
    [super visit];
	glDisable(GL_SCISSOR_TEST);
}

-(void) moveFirstGrid {
    // Set up actions to shift the grid around
    CCMoveBy *left = [CCMoveBy actionWithDuration:1.0
                            position:ccp(-10,-10)];
    CCMoveBy *right = [CCMoveBy actionWithDuration:1.0
                            position:ccp(20,20)];
    CCMoveBy *back = [CCMoveBy actionWithDuration:1.0
                            position:ccp(-10,-10)];
 
    CCTintBy *tintA = [CCTintBy actionWithDuration:8.0
                        red:255 green:255 blue:0];
    CCTintBy *tintB = [CCTintBy actionWithDuration:4.0
                        red:0 green:255 blue:255];
    
    CCRepeatForever *repeater = [CCRepeatForever 
        actionWithAction:[CCSequence actions:
                          left,
                          right,
                          back, nil]];
    CCRepeatForever *repeater2 = [CCRepeatForever
                                  actionWithAction:
                                  [CCSequence actions:
                                   tintA, tintB, nil]];
    
    [[firstGrid sprite] runAction:repeater];
    [[firstGrid sprite] runAction:repeater2];    
    
}

-(void) moveSecondGrid {
    // Set up actions to shift the grid around
    CCMoveBy *left = [CCMoveBy actionWithDuration:1.0
                            position:ccp(-10,10)];
    CCMoveBy *right = [CCMoveBy actionWithDuration:1.0
                            position:ccp(20,-20)];
    CCMoveBy *back = [CCMoveBy actionWithDuration:1.0
                            position:ccp(-10,10)];
    
    CCTintBy *tintA = [CCTintBy actionWithDuration:5.0
                            red:0 green:0 blue:0];
    CCTintBy *tintB = [CCTintBy actionWithDuration:6.0
                            red:255 green:255 blue:255];
    
    CCRepeatForever *repeater = [CCRepeatForever 
                                 actionWithAction:
                                 [CCSequence actions:
                                  left,
                                  right,
                                  back, nil]];
    CCRepeatForever *repeater2 = [CCRepeatForever
                                  actionWithAction:
                                  [CCSequence actions:
                                   tintA, tintB, nil]];
    
    [secondGrid runAction:repeater];
    [secondGrid runAction:repeater2];    
    
}


-(void) drawGrid {
    // We draw the initial grid on a render texture

    // Start drawing on the Render Texture
    [firstGrid begin];
    
    glLineWidth( 3.0f * CC_CONTENT_SCALE_FACTOR() );
    ccDrawColor4F(1, 1, 1, 1);
    
    float left = 0;
    float right = firstGrid.sprite.textureRect.size.width;
    float top = firstGrid.sprite.textureRect.size.height;
    float bottom = 0;
    float gridSize = 40;
    
    // Draw the vertical lines
    for (float x = left; x <= right; x+=gridSize) {
        ccDrawLine(ccp(x, bottom), ccp(x, top));
    }
    
    // Draw the horizontal lines
    for (float y = bottom; y <= top; y+=gridSize) {
        ccDrawLine(ccp(left, y), ccp(right, y));
    }
    
    // Done drawing on the Render Texture
    [firstGrid end];
    
}

@end
