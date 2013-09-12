//
//  ExtrasController.h
//  Belt Commander
//
//  Created by Lucas Jordan on 8/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "GameParameters.h"

@interface ExtrasController : UIViewController<SKPaymentTransactionObserver, SKProductsRequestDelegate>{
    GameParameters* gameParams;
    NSMutableDictionary* idsToProducts;
}
@property (strong, nonatomic) IBOutlet UIButton *asteroidButton;
@property (strong, nonatomic) IBOutlet UIButton *saucerButton;
@property (strong, nonatomic) IBOutlet UIButton *powerupButton;

-(void)setGameParams:(GameParameters*)params;
-(GameParameters*)gameParams;
@end
