//
//  CoinsController.m
//  Sample 04
//
//  Created by Lucas Jordan on 4/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/CoreAnimation.h>
#import "CoinsController.h"

UIImage* imageForCoin(int coin){
    if (coin == COIN_TRIANGLE){
        return [UIImage imageNamed:@"coin_triangle0001"];
    } else if (coin == COIN_SQUARE){
        return [UIImage imageNamed:@"coin_square0001"];
    } else if (coin == COIN_CIRCLE){
        return [UIImage imageNamed:@"coin_circle0001"];
    } 
    return nil;
}

NSString* prefixFromCoin(int coin){
    if (coin == COIN_TRIANGLE){
        return @"coin_triangle";
    } else if (coin == COIN_SQUARE){
        return @"coin_square";
    } else if (coin == COIN_CIRCLE){
        return @"coin_circle";
    } 
    return nil;
}

@implementation CoinsController
@synthesize delegate;
@synthesize coinsGame;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    CGRect viewFrame = [self.view frame];
    
    //border is 3.125
    float border = viewFrame.size.width*.03125;
    float coinsViewWidth = viewFrame.size.width-border*2;
    CGRect coinsFrame = CGRectMake(border, border, coinsViewWidth, coinsViewWidth);
    
    coinsView = [[UIView alloc] initWithFrame: coinsFrame];
    [coinsView setBackgroundColor:[UIColor whiteColor]];
    [coinsView setClipsToBounds:YES];
    
    [self.view addSubview:coinsView];
    
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer setNumberOfTouchesRequired:1];
    
    [coinsView addGestureRecognizer:tapRecognizer];
    
}

-(void)loadImages{
    if (imageSequences == nil){
        imageSequences = [NSMutableArray new];
        [imageSequences addObject: [CoinsController fillImageArray: COIN_TRIANGLE]];
        [imageSequences addObject: [CoinsController fillImageArray: COIN_SQUARE]];
        [imageSequences addObject: [CoinsController fillImageArray: COIN_CIRCLE]];
    }
}

+(NSArray*)fillImageArray:(int)coin {
    NSMutableArray* result = [NSMutableArray new];
    NSString* prefix = prefixFromCoin(coin);
    
    for (int i=1;i<32;i++){
        NSString* imageName = [prefix stringByAppendingString:[NSString stringWithFormat: @"%04d", i]];
        UIImage* image = [UIImage imageNamed:imageName];
        [result addObject: image];
    }
    return result;
}

-(void)continueGame:(CoinsGame*)aCoinsGame{
    for (UIView* view in [coinsView subviews]){
        [view removeFromSuperview];
    }
    
    [coinsGame release];
    coinsGame = aCoinsGame;
    
    [self createAndLayoutImages]; 
    [delegate gameDidStart:self with: coinsGame];
    [delegate scoreIncreases:self with:[coinsGame score]];
    [delegate turnsRemainingDecreased:self with:[coinsGame remaingTurns]];
    
    acceptingInput = YES;
}
-(void)newGame{
    for (UIView* view in [coinsView subviews]){
        [view removeFromSuperview];
    }
    
    [coinsGame release];
    coinsGame = [[CoinsGame alloc] initRandomWithRows:5 Cols:5];
    
    [self createAndLayoutImages];
    [delegate gameDidStart:self with: coinsGame];
    
    acceptingInput = YES;
}

-(void)createAndLayoutImages{
    int rowCount = [coinsGame rowCount];
    int colCount = [coinsGame colCount];
    
    imageViews = [NSMutableArray new];
    CGRect coinsFrame = [coinsView frame];
    float width = coinsFrame.size.width/colCount;
    float height = coinsFrame.size.height/rowCount;


    for (int r=0;r<rowCount;r++){
        for (int c=0;c<colCount;c++){
            
            UIImageView* imageView = [[UIImageView alloc] init];
            CGRect frame = CGRectMake(c*width, r*height, width, height);
            [imageView setFrame:frame];
            
            [coinsView addSubview: imageView];
            [self spinCoinAt:CoordMake(r, c)];
        }
    }

}

- (void)tapGesture:(UIGestureRecognizer *)gestureRecognizer{
    
    if ([coinsGame remaingTurns] > 0 && acceptingInput){
        UITapGestureRecognizer* tapRegognizer = (UITapGestureRecognizer*)gestureRecognizer;
        CGPoint location = [tapRegognizer locationInView:coinsView];
        Coord coinCoord = [self coordFromLocation:location];
        
        if (!isFirstCoinSelected){//first of the pair
            isFirstCoinSelected = true;
            firstSelectedCoin = coinCoord;
            [self stopCoinAt: firstSelectedCoin];
        } else {
            if (CoordEqual(firstSelectedCoin, coinCoord)){//re selected the first one.
                isFirstCoinSelected = false;
                
                [self spinCoinAt:firstSelectedCoin];
            } else {//selected another one, do switch.
                acceptingInput = false;
                [coinsGame setRemaingTurns: [coinsGame remaingTurns] - 1];
                [delegate turnsRemainingDecreased:self with: [coinsGame remaingTurns]];
                
                isFirstCoinSelected = false;
                secondSelectedCoin = coinCoord;
                [self stopCoinAt:secondSelectedCoin];
                [self doSwitch:firstSelectedCoin With:secondSelectedCoin];
            }
        }
    }
    
}

-(void)doSwitch:(Coord)coordA With:(Coord)coordB {
    [coinsGame swap:coordA With:coordB];
    
    coinViewA = [[coinsView subviews] objectAtIndex:[coinsGame indexForCoord:coordA]];
    coinViewB = [[coinsView subviews] objectAtIndex:[coinsGame indexForCoord:coordB]];
    
    CABasicAnimation* animScaleDownA = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [animScaleDownA setValue:@"animScaleDownA" forKey:@"name"];
    animScaleDownA.fromValue = [NSNumber numberWithFloat:1.0f];
    animScaleDownA.toValue = [NSNumber numberWithFloat:0.0f];
    animScaleDownA.duration = 1.0;
    animScaleDownA.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [animScaleDownA setDelegate:self];
    
    CABasicAnimation* animScaleUpA = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [animScaleUpA setValue:@"animScaleUpA" forKey:@"name"];
    animScaleUpA.fromValue = [NSNumber numberWithFloat:0.0f];
    animScaleUpA.toValue = [NSNumber numberWithFloat:1.0f];
    animScaleUpA.duration = 1.0;
    animScaleUpA.beginTime = CACurrentMediaTime() + 1.0;
    animScaleUpA.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [animScaleUpA setDelegate:self];
    
    
    [coinViewA.layer addAnimation:animScaleDownA forKey:@"animScaleDown"];
    [coinViewA.layer addAnimation:animScaleUpA forKey:@"animScaleUp"];
    
    CABasicAnimation* animScaleDownB = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [animScaleDownB setValue:@"animScaleDownB" forKey:@"name"];
    animScaleDownB.fromValue = [NSNumber numberWithFloat:1.0f];
    animScaleDownB.toValue = [NSNumber numberWithFloat:0.0f];
    animScaleDownB.duration = 1.0;
    animScaleDownB.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation* animScaleUpB = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [animScaleUpB setValue:@"animScaleUpB" forKey:@"name"];
    animScaleUpB.fromValue = [NSNumber numberWithFloat:0.0f];
    animScaleUpB.toValue = [NSNumber numberWithFloat:1.0f];
    animScaleUpB.duration = 1.0;
    animScaleUpB.beginTime = CACurrentMediaTime() + 1.0;
    animScaleUpB.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [coinViewB.layer addAnimation:animScaleDownB forKey:@"animScaleDown"];
    [coinViewB.layer addAnimation:animScaleUpB forKey:@"animScaleUp"];
    
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
    if ([[theAnimation valueForKey:@"name"] isEqual:@"animScaleDownA"]){
        
        UIImage* imageA = [coinViewA image];
        [coinViewA setImage:[coinViewB image]];
        [coinViewB setImage:imageA];
        
    } else if ([[theAnimation valueForKey:@"name"] isEqual:@"animScaleUpA"]){
        
        [self checkMatches];
        [self spinCoinAt:firstSelectedCoin];
        [self spinCoinAt:secondSelectedCoin];
        
    } else if ([[theAnimation valueForKey:@"name"] isEqual:@"animateOffScreen"]){
        
        [coinsGame randomizeRows: matchingRows];
        [coinsGame randomizeCols: matchingCols];
        [self updateCoinViews];
        
    }
}

-(void)spinCoinAt:(Coord)coord{
    UIImageView* coinView = [[coinsView subviews] objectAtIndex:[coinsGame indexForCoord:coord]];
    
    NSNumber* coin = [coinsGame coinForCoord:coord];
    NSArray* images = [imageSequences objectAtIndex:[coin intValue]];
    [coinView setAnimationImages: images];
    NSTimeInterval interval = (random()%4)/10.0+.6;
    [coinView setAnimationDuration: interval];
    [coinView startAnimating];
}
-(void)stopCoinAt:(Coord)coord{
    UIImageView* coinView = [[coinsView subviews] objectAtIndex:[coinsGame indexForCoord:coord]];
    NSNumber* coin = [coinsGame coinForCoord:coord];
    
    UIImage* image = imageForCoin([coin intValue]);
    [coinView stopAnimating];
    [coinView setImage: image];
}

-(void)updateCoinViews{
    int rowCount = [coinsGame rowCount];
    int colCount = [coinsGame colCount];
    
    for (NSNumber* row in matchingRows){
        for (int c=0;c<colCount;c++){
            Coord coord = CoordMake([row intValue], c);
            [self spinCoinAt:coord];
        }
    }
    for (NSNumber* col in matchingCols){
        for (int r=0;r<rowCount;r++){
            Coord coord = CoordMake(r, [col intValue]);
            [self spinCoinAt:coord];
        }
    }
    [self checkMatches];
}

-(void)checkMatches{
    
    matchingRows = [coinsGame findMatchingRows];
    matchingCols = [coinsGame findMatchingCols];
    
    int rowCount = [coinsGame rowCount];
    int colCount = [coinsGame colCount];
    
    if ([matchingRows count] > 0){
        for (NSNumber* row in matchingRows){
            for (int c=0;c<colCount;c++){
                
                CABasicAnimation* animateOffScreen = [CABasicAnimation animationWithKeyPath:@"position.x"];
                [animateOffScreen setValue:@"animateOffScreen" forKey:@"name"];
                animateOffScreen.byValue = [NSNumber numberWithFloat:coinsView.frame.size.width];
                animateOffScreen.duration = 2.0;
                animateOffScreen.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
                if (c == 0){
                    [animateOffScreen setDelegate:self];
                }
                
                Coord coord = CoordMake([row intValue], c);
                int index = [coinsGame indexForCoord:coord];
                UIImageView* coinView = [[coinsView subviews] objectAtIndex: index];
                [coinView.layer addAnimation:animateOffScreen forKey:@"animateOffScreenX"];
            }
        }
    }
    
    if ([matchingCols count] > 0){
        for (NSNumber* col in matchingCols){
            for (int r=0;r<rowCount;r++){
                CABasicAnimation* animateOffScreen = [CABasicAnimation animationWithKeyPath:@"position.y"];
                [animateOffScreen setValue:@"animateOffScreen" forKey:@"name"];
                animateOffScreen.byValue = [NSNumber numberWithFloat:coinsView.frame.size.height];
                animateOffScreen.duration = 2.0;
                animateOffScreen.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
                if ([matchingRows count] == 0 && r==0){
                    [animateOffScreen setDelegate:self];
                }
                
                Coord coord = CoordMake(r, [col intValue]);
                int index = [coinsGame indexForCoord:coord];
                UIImageView* coinView = [[coinsView subviews] objectAtIndex: index];
                [coinView.layer addAnimation:animateOffScreen forKey:@"animateOffScreenY"];
            }
        }
    }
    
    int totalMatches = [matchingCols count] + [matchingRows count];
    if (totalMatches > 0){
        [coinsGame setScore:[coinsGame score] + totalMatches];
        [delegate scoreIncreases:self with:[coinsGame score]];
    } else {
        if ([coinsGame remaingTurns] <= 0){
            //delay calling gameOver on the delegate so the coin's UIImageViews show the correct coin.
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doEndGame) userInfo:nil repeats:FALSE];
        } else {
            //all matches are done animating and we have turns left.
            acceptingInput = YES;
        }
    }
}
-(void)doEndGame{
    [delegate gameOver:self with: coinsGame];
}

-(Coord)coordFromLocation:(CGPoint) location{
    CGRect coinsFrame = [coinsView frame];
    Coord result;
    result.col = location.x / coinsFrame.size.width * [coinsGame colCount];
    result.row = location.y / coinsFrame.size.height * [coinsGame rowCount];
    
    return result;
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
    [super dealloc];
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
@end


