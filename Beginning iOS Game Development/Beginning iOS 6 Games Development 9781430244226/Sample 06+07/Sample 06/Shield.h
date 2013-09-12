//
//  Shield.h
//  Sample 06
//
//  Created by Lucas Jordan on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Actor.h"
#import "Bullet.h"

@interface Shield : Actor{
    
}
+(id)shieldProtecting:(Actor*)anActor From:(Bullet*)bullet;
@end
