//
//  Bullet.h
//  Sample 06
//
//  Created by Lucas Jordan on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Actor.h"
#import "VectorRepresentation.h"
#import "GameController.h"

@interface Bullet : Actor<VectorRepresentationDelegate> {
    
}
@property (nonatomic) float damage;
@property (nonatomic, strong) Actor* source;

+(id)bulletAt:(CGPoint)aCenter WithDirection:(float)aDirection From:(Actor*)actor;
+(id)bulletAt:(CGPoint)aCenter TowardPoint:(CGPoint)aPoint From:(Actor*)actor;
+(id)bulletAt:(CGPoint)aCenter WithDirection:(float)aDirection;
+(id)bulletAt:(CGPoint)aCenter TowardPoint:(CGPoint)aPoint;
-(void)decrementDamage:(GameController*)gameController;
@end
