//
//  AsteroidRepresentationDelegate.h
//  Sample 06
//
//  Created by Lucas Jordan on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageRepresentation.h"


enum{
    VARIATION_A = 0,
    VARIATION_B,
    VARIATION_C,
    AST_VARIATION_COUNT
};

@interface AsteroidRepresentationDelegate : NSObject<ImageRepresentationDelegate> {
    
}
+(AsteroidRepresentationDelegate*)instance;
@end
