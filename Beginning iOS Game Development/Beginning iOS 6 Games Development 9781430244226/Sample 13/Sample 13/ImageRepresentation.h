//
//  ImageSequenceRepresentation.h
//  Sample 06
//
//  Created by Lucas Jordan on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Actor.h"

@protocol ImageRepresentationDelegate

@required
-(NSString*)baseImageName;

@optional
-(int)getFrameCountForVariant:(int)aVariant AndState:(int)aState;
-(NSString*)getNameForVariant:(int)aVariant;
-(NSString*)getNameForState:(int)aState;

@end

@interface ImageRepresentation : NSObject<Representation> {
    UIView* view;
}
@property (nonatomic, assign) NSObject<ImageRepresentationDelegate>* delegate;
@property (nonatomic, retain) NSString* baseImageName;
@property (nonatomic) int currentFrame;
@property (nonatomic) BOOL backwards;
@property (nonatomic) int stepsPerFrame;

+(id)imageRep;
+(id)imageRepWithName:(NSString*)aBaseImageName;
+(id)imageRepWithDelegate:(NSObject<ImageRepresentationDelegate>*)aDelegate;
-(void)advanceFrame:(Actor*)actor ForStep:(int)step;
-(NSString*)getImageNameForActor:(Actor*)actor;
-(UIImage*)getImageForActor:(Actor*)actor;

@end
