//
//  ImageListViewController.h
//  ImageGrabber
//
//  Created by Ray Wenderlich on 7/3/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageManager.h"
@class ImageDetailViewController;

@interface ImageListViewController : UITableViewController <ImageManagerDelegate>  {
    
}

@property (retain) UIActivityIndicatorView * activityIndicator;
@property (retain) NSMutableArray * imageInfos;
@property (retain) ImageManager * imageManager;
@property (retain) NSString * html;
@property (retain) ImageDetailViewController * imageDetailViewController;

@end
