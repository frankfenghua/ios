//
//  Viper01.h
//  Sample 05
//
//  Created by Lucas Jordan on 4/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Viper01 : UIImageView {
}
@property float speed;
@property CGPoint moveToPoint;
-(void)updateLocation;
@end
