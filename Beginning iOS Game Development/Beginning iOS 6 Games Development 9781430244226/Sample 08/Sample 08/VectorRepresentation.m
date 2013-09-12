//
//  VectorRepresentation.m
//  Sample 06
//
//  Created by Lucas Jordan on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VectorRepresentation.h"
#import "VectorActorView.h"

@implementation VectorRepresentation
@synthesize delegate;

+(id)vectorRepresentation{
    return [VectorRepresentation new];
}
-(UIView*)getViewForActor:(Actor*)anActor In:(GameController*)aController{
    if (view == nil){
        view = [VectorActorView new];
        [view setBackgroundColor:[UIColor clearColor]];
        [view setActor: anActor];
        [view setDelegate:delegate];
        [anActor setNeedsViewUpdated:YES];
    }
    return view;    
}
-(void)updateView:(UIView*)aView ForActor:(Actor*)anActor In:(GameController*)aController{
    if ([anActor needsViewUpdated]){
        [aView setNeedsDisplay];
        [anActor setNeedsViewUpdated:NO];
    }
}
@end
