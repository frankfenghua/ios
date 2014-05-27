//
//  ImageDetailViewController.h
//  ImageGrabber
//
//  Created by Ray Wenderlich on 7/3/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageInfo;

@interface ImageDetailViewController : UIViewController {
        
    UIImageView *imageView;
}

@property (retain) ImageInfo * info;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;

@end
