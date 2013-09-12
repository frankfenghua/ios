//
//  Powerup.h
//  Sample 06
//
//  Created by Lucas Jordan on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Actor.h"
#import "ImageRepresentation.h"
#import "ExpireAfterTime.h"
#import "Viper.h"

enum{
    STATE_GLOW = 0,
    STATE_NO_GLOW,
    PWR_STATE_COUNT
};

enum{
    VARIATION_HEALTH = 0,
    VARIATION_CASH,
    VARIATION_DAMAGE,
    PWR_VARIATION_COUNT
};

@interface Powerup : Actor <ImageRepresentationDelegate,ExpireAfterTimeDelegate>{
    
}
+(id)powerup:(GameController*)gameController;
+(id)powerup:(GameController*)gameController At:(CGPoint)center;
-(void)doHitOn:(Viper*)viper in:(GameController*)gameController;
@end
