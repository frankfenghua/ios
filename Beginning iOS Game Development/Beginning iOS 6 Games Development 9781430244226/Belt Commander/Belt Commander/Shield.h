//
//  Shield.h
//  Sample 06
//
//  Created by Lucas Jordan on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Actor.h"
#import "ExpireAfterTime.h"
#import "Particle.h"

@interface Shield : Particle<ExpireAfterTimeDelegate>{
    
}
+(id)shieldProtecting:(Actor*)anActor From:(Actor*)otherActor;
@end
