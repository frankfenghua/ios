//
//  VectorRepresentation.h
//  Sample 06
//
//  Created by Lucas Jordan on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Actor.h"

@class VectorActorView;

@protocol VectorRepresentationDelegate
-(void)drawActor:(Actor*)anActor WithContext:(CGContextRef)context InRect:(CGRect)rect;
@end

@interface VectorRepresentation : NSObject<Representation> {
    VectorActorView* view;
}
@property (nonatomic, assign) NSObject<VectorRepresentationDelegate>* delegate;
+(id)vectorRepresentation;
@end
