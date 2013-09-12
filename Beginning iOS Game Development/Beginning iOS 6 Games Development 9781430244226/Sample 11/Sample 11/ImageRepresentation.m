//
//  ImageSequenceRepresentation.m
//  Sample 06
//
//  Created by Lucas Jordan on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageRepresentation.h"
#import "GameController.h"

@implementation ImageRepresentation
@synthesize delegate;
@synthesize baseImageName;
@synthesize currentFrame;
@synthesize backwards;
@synthesize stepsPerFrame;

+(id)imageRep{
    ImageRepresentation* representation = [ImageRepresentation new];
    [representation setCurrentFrame:1];
    [representation setStepsPerFrame:1];
    return representation;
}
+(id)imageRepWithName:(NSString*)aBaseImageName{
    ImageRepresentation* representation = [ImageRepresentation imageRep];
    [representation setBaseImageName:aBaseImageName];
    return representation;
}

+(id)imageRepWithDelegate:(NSObject<ImageRepresentationDelegate>*)aDelegate{
    ImageRepresentation* representation = [ImageRepresentation imageRep];
    [representation setDelegate:aDelegate];
    return representation;
}

-(UIView*)getViewForActor:(Actor*)actor In:(GameController*)aController{
    if (view == nil){
        UIImage* image = [self getImageForActor: actor];
        view = [[UIImageView alloc] initWithImage: image];
    }
    return view;
}
-(void)updateView:(UIView*)aView ForActor:(Actor*)anActor In:(GameController*)aController{
    
    if ([delegate respondsToSelector:@selector(getFrameCountForVariant:AndState:)]){
        [self advanceFrame: anActor ForStep:[aController stepNumber]];
    }
    
    if ([anActor needsViewUpdated]){
        
        UIImageView* imageView = (UIImageView*)aView;
        UIImage* image = [self getImageForActor: anActor];
        
        [imageView setImage:image];
        [anActor setNeedsViewUpdated:NO];
    }
}


-(void)advanceFrame:(Actor*)actor ForStep:(int)step{
    if (![actor animationPaused]){
        if (step % self.stepsPerFrame == 0){
            if (self.backwards){
                self.currentFrame -= 1;
            } else {
                self.currentFrame += 1;
            }
            
            int frameCount = [delegate getFrameCountForVariant:[actor variant] AndState:[actor state]];
            if (self.currentFrame > frameCount){
                self.currentFrame = 1;
            }
            if (self.currentFrame < 1){
                self.currentFrame = frameCount;
            }
            
            [actor setNeedsViewUpdated:YES];
        }
    }
}

-(NSString*)getImageNameForActor:(Actor*)actor{
    NSString* imageName = baseImageName;
    
    if (imageName == nil){
        imageName = [delegate baseImageName];
    }
    NSString* variant = nil;
    if ([delegate respondsToSelector:@selector(getNameForVariant:)]){
        variant = [delegate getNameForVariant:[actor variant]];
    }
    NSString* state = nil;
    if ([delegate respondsToSelector:@selector(getNameForState:)]){
        state = [delegate getNameForState:[actor state]];
    }
    int frameCount = 0;
    if ([delegate respondsToSelector:@selector(getFrameCountForVariant:AndState:)]){
        frameCount = [delegate getFrameCountForVariant:[actor variant] AndState:[actor state]];
    }
    if (variant != nil){
        imageName = [[imageName stringByAppendingString:@"_"] stringByAppendingString:variant];
    }
    if (state != nil){
        imageName = [[imageName stringByAppendingString:@"_"] stringByAppendingString:state];
    }
    if (frameCount != 0){
        imageName = [[imageName stringByAppendingString:@"_"] stringByAppendingString:[NSString stringWithFormat:@"%04d", currentFrame] ];
    }
    return imageName;
}

-(UIImage*)getImageForActor:(Actor*)actor{
    NSString* imageName = [self getImageNameForActor:actor];
    
    UIImage* result = [UIImage imageNamed: imageName];
    if (result == nil){
        NSLog(@"Image Not Found: %@", imageName);
    }
	return result;
}
@end
