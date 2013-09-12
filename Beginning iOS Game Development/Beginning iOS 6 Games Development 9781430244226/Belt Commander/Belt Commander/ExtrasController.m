//
//  ExtrasController.m
//  Belt Commander
//
//  Created by Lucas Jordan on 8/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ExtrasController.h"

@implementation ExtrasController
@synthesize asteroidButton;
@synthesize saucerButton;
@synthesize powerupButton;


- (IBAction)asteroidButtonClicked:(id)sender {
    [gameParams setIncludeAsteroids:![gameParams includeAsteroids]];
    [self setGameParams:gameParams];
    [gameParams writeToDefaults];
}
- (IBAction)saucerButtonClicked:(id)sender {
    if ([gameParams.purchases containsObject:PURCHASE_INGAME_SAUCERS]){
        [gameParams setIncludeSaucers:![gameParams includeSaucers]];
        [self setGameParams:gameParams];
        [gameParams writeToDefaults];
    } else {
        SKProduct* product = [idsToProducts objectForKey:PURCHASE_INGAME_SAUCERS];
        SKPayment* payRequest = [SKPayment paymentWithProduct: product];
        [[SKPaymentQueue defaultQueue] addPayment:payRequest];
    }
}
- (IBAction)powerupButtonClicked:(id)sender {
    if ([gameParams.purchases containsObject:PURCHASE_INGAME_POWERUPS]){
        [gameParams setIncludePowerups:![gameParams includePowerups]];
        [self setGameParams:gameParams];
        [gameParams writeToDefaults];
    } else {
        SKProduct* product = [idsToProducts objectForKey:PURCHASE_INGAME_POWERUPS];
        SKPayment* payRequest = [SKPayment paymentWithProduct: product];
        [[SKPaymentQueue defaultQueue] addPayment:payRequest];
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for (SKPaymentTransaction* transaction in transactions){
        if (transaction.transactionState == SKPaymentTransactionStatePurchased || transaction.transactionState == SKPaymentTransactionStateRestored){
            NSString* productIdentifier = transaction.payment.productIdentifier;
            
            [[gameParams purchases] addObject: productIdentifier];
            [gameParams writeToDefaults];
            
            [self setGameParams:gameParams];
            
            [queue finishTransaction:transaction];
        }
    }
}
-(GameParameters*)gameParams{
    return gameParams;
}
-(void)setGameParams:(GameParameters*)params{
    gameParams = params;
    NSSet* purchases = [gameParams purchases];
    
    if ([params includeAsteroids]){
        [asteroidButton setImage:[UIImage imageNamed:@"asteroid_active"] forState:UIControlStateNormal];
    } else {
        [asteroidButton setImage:[UIImage imageNamed:@"asteroid_inactive"] forState:UIControlStateNormal];
    }

    if ([purchases containsObject:PURCHASE_INGAME_SAUCERS]){
        if ([params includeSaucers]){
            [saucerButton setImage:[UIImage imageNamed:@"saucer_active"] forState:UIControlStateNormal];
        } else {
            [saucerButton setImage:[UIImage imageNamed:@"saucer_inactive"] forState:UIControlStateNormal];
        }
    } else {
        [saucerButton setImage:[UIImage imageNamed:@"saucer_purchase"] forState:UIControlStateNormal];
    }
    
    if ([purchases containsObject:PURCHASE_INGAME_POWERUPS]){
        if ([params includePowerups]){
            [powerupButton setImage:[UIImage imageNamed:@"powerup_active"] forState:UIControlStateNormal];
        } else {
            [powerupButton setImage:[UIImage imageNamed:@"powerup_inactive"] forState:UIControlStateNormal];
        }
    } else {
        [powerupButton setImage:[UIImage imageNamed:@"powerup_purchase"] forState:UIControlStateNormal];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)restorePurchasesClicked:(id)sender {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    idsToProducts = [NSMutableDictionary new];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    //Get set of product ids
    NSSet* potentialProcucts = [NSSet setWithObjects:PURCHASE_INGAME_POWERUPS, PURCHASE_INGAME_SAUCERS, nil];
    
    SKProductsRequest* request = [[SKProductsRequest alloc] initWithProductIdentifiers:potentialProcucts];
    [request setDelegate:self];
    [request start];
    
    [self setGameParams: [GameParameters readFromDefaults]];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    for (SKProduct* aProduct in response.products){
        if ([aProduct.productIdentifier isEqualToString:PURCHASE_INGAME_SAUCERS]){
            [saucerButton setEnabled:YES];
            [saucerButton setHidden:NO];
            [idsToProducts setObject:aProduct forKey:PURCHASE_INGAME_SAUCERS];
        } else if ([aProduct.productIdentifier isEqualToString:PURCHASE_INGAME_POWERUPS]){
            [powerupButton setEnabled:YES];
            [powerupButton setHidden:NO];
            [idsToProducts setObject:aProduct forKey:PURCHASE_INGAME_POWERUPS];
        }
    }
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
