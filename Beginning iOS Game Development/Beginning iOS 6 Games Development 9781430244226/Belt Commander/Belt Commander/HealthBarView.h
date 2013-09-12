//
//  HealthBarView.h
//  Belt Commander
//
//  Created by Lucas Jordan on 8/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthBarView : UIView{
    NSArray* percents;
    NSArray* colors;
    float percent;
}

-(void)setColorRanged:(NSArray*)thePercents colors:(NSArray*)theColors;
-(void)setHealth:(float)aPercent;

@end
