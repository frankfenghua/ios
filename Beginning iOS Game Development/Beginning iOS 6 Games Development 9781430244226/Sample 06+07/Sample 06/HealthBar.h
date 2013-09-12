//
//  HealthBar.h
//  Sample 06
//
//  Created by Lucas Jordan on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Actor.h"
#import "VectorRepresentation.h"

@interface HealthBar : Actor<VectorRepresentationDelegate> {
    
}
@property (nonatomic) float percent;
@property (nonatomic, strong) UIColor* color;
@property (nonatomic, strong) UIColor* backgroundColor;

+(id)healthBar:(Actor*)anActor;


@end
