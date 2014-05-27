//
//  ImageInfo.h
//  ImageGrabber
//
//  Created by Ray Wenderlich on 7/3/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageInfo : NSObject {
    
}

- (id)initWithSourceURL:(NSURL *)URL;
- (id)initWithSourceURL:(NSURL *)URL imageName:(NSString *)name image:(UIImage *)i;

@property (retain) NSURL * sourceURL;
@property (retain) NSString * imageName;
@property (nonatomic, retain) UIImage * image;

@end
