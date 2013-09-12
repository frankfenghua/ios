//
//  Viper.h
//  Sample 08
//
//  Created by Lucas Jordan on 8/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Actor.h"
#import "GameController.h"
#import "ImageRepresentation.h"

enum{
    VPR_STATE_STOPPED = 0,
    VPR_STATE_CLOCKWISE,
    VPR_STATE_COUNTER_CLOCKWISE,
    VPR_STATE_TRAVELING,
    VPR_STATE_COUNT
};

@interface Viper : Actor <ImageRepresentationDelegate>

+(id)viper:(GameController*)gameController;

@end
