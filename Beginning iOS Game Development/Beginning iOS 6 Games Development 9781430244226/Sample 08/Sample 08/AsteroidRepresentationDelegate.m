//
//  AsteroidRepresentationDelegate.m
//  Sample 06
//
//  Created by Lucas Jordan on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AsteroidRepresentationDelegate.h"



@implementation AsteroidRepresentationDelegate

+(AsteroidRepresentationDelegate*)instance{
    static AsteroidRepresentationDelegate* instance;
    @synchronized(self) {
		if(!instance) {
			instance = [AsteroidRepresentationDelegate new];
		}
	}
	return instance;
}
-(int)getFrameCountForVariant:(int)aVariant AndState:(int)aState{
    return 31;
}
-(NSString*)getNameForVariant:(int)aVariant{
    if (aVariant == VARIATION_A){
        return @"A";
    } else if (aVariant == VARIATION_B){
        return @"B";
    } else if (aVariant == VARIATION_C){
        return @"C";
    } else {
        return nil;
    }
    
}
-(NSString*)baseImageName{
    return @"Asteroid";
}
@end
