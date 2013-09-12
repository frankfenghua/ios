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
#import "LinearMotion.h"


@interface Viper : Actor <ImageRepresentationDelegate>{
}

+(id)viper:(GameController*)gameController;

@end
