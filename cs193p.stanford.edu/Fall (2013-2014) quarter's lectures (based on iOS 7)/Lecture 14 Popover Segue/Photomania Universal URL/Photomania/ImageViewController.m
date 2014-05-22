//
//  ImageViewController.m
//  Imaginarium
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "ImageViewController.h"
#import "URLViewController.h"

@interface ImageViewController () <UIScrollViewDelegate, UISplitViewControllerDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
// this is weak because we want it to go back to nil
//   when no one else has strong pointer to the popover (i.e. it is dismissed)
@property (weak, nonatomic) UIPopoverController *urlPopoverController;
@end

@implementation ImageViewController

#pragma mark - View Controller Lifecycle

// add the UIImageView to the MVC's View

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
}

#pragma mark - Properties

// lazy instantiation

- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] init];
    return _imageView;
}

// image property does not use an _image instance variable
// instead it just reports/sets the image in the imageView property
// thus we don't need @synthesize even though we implement both setter and getter

- (UIImage *)image
{
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image; // does not change the frame of the UIImageView

    // had to add these two lines in Shutterbug to fix a bug in "reusing" ImageViewController's MVC
    self.scrollView.zoomScale = 1.0;
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // self.scrollView could be nil on the next line if outlet-setting has not happened yet
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;

    // in portrait orientation on an iPad in a split view,
    //   unfortunately the master can be access while popover is up
    //   (so dismiss the URL if someone changes our image from there)
    [self.urlPopoverController dismissPopoverAnimated:YES];

    [self.spinner stopAnimating];
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    
    // next three lines are necessary for zooming
    _scrollView.minimumZoomScale = 0.2;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.delegate = self;

    // next line is necessary in case self.image gets set before self.scrollView does
    // for example, prepareForSegue:sender: is called before outlet-setting phase
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
}

#pragma mark - UIScrollViewDelegate

// mandatory zooming method in UIScrollViewDelegate protocol

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark - Navigation

// show our imageURL in a popover
// stash the popover so that we can ensure that only one appears at a time

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[URLViewController class]]) {
        URLViewController *urlvc = (URLViewController *)segue.destinationViewController;
        // if we are segueing to a popover, the segue itself will be a UIStoryboardPopoverSegue
        if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
            UIStoryboardPopoverSegue *popoverSegue = (UIStoryboardPopoverSegue *)segue;
            self.urlPopoverController = popoverSegue.popoverController;
        }
        urlvc.url = self.imageURL;
    }
}

// don't show the URL if it's already showing or we don't have a URL to show

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"Show URL"]) {
        return self.urlPopoverController ? NO : (self.imageURL ? YES : NO);
    } else {
        return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    }
}

#pragma mark - Setting the Image from the Image's URL

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    //    self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageURL]]; // blocks main queue!
    [self startDownloadingImage];
}

- (void)startDownloadingImage
{
    self.image = nil;

    if (self.imageURL)
    {
        [self.spinner startAnimating];

        NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL];
        
        // another configuration option is backgroundSessionConfiguration (multitasking API required though)
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        
        // create the session without specifying a queue to run completion handler on (thus, not main queue)
        // we also don't specify a delegate (since completion handler is all we need)
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];

        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
            completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
                // this handler is not executing on the main queue, so we can't do UI directly here
                if (!error) {
                    if ([request.URL isEqual:self.imageURL]) {
                        // UIImage is an exception to the "can't do UI here"
                        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
                        // but calling "self.image =" is definitely not an exception to that!
                        // so we must dispatch this back to the main queue
                        dispatch_async(dispatch_get_main_queue(), ^{ self.image = image; });
                    }
                }
        }];
        [task resume]; // don't forget that all NSURLSession tasks start out suspended!
    }
}

#pragma mark - UISplitViewControllerDelegate

// this section added during Shutterbug demo

- (void)awakeFromNib
{
    self.splitViewController.delegate = self;
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = aViewController.title;
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.navigationItem.leftBarButtonItem = nil;
}

@end
