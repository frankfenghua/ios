//
//  BIDDetailViewController.m
//  Presidents
//

#import "BIDDetailViewController.h"
#import "BIDLanguageListController.h"

@interface BIDDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation BIDDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (self.detailItem != newDetailItem) {
        _detailItem = modifyUrlForLanguage(newDetailItem, self.languageString);
        
        // Update the view.
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)setLanguageString:(NSString *)newString {
    if (![newString isEqualToString:self.languageString]) {
        _languageString = [newString copy];
        self.detailItem = modifyUrlForLanguage(_detailItem, self.languageString);
    }
    if (self.languagePopoverController != nil) {
        [self.languagePopoverController dismissPopoverAnimated:YES];
        self.languagePopoverController = nil;
    }
}

static NSString * modifyUrlForLanguage(NSString *url, NSString *lang) {
    if (!lang) {
        return url;
    }
    
    // We're relying on a particular Wikipedia URL format here. This
    // is a bit fragile!
    NSRange languageCodeRange = NSMakeRange(7, 2);
    if ([[url substringWithRange:languageCodeRange] isEqualToString:lang]) {
        return url;
    } else {
        NSString *newUrl = [url stringByReplacingCharactersInRange:languageCodeRange
                                                        withString:lang];
        return newUrl;
    }
}

- (void)configureView
{
    NSURL *url = [NSURL URLWithString:self.detailItem];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.languageButton =
        [[UIBarButtonItem alloc] initWithTitle:@"Choose Language"
                                         style:UIBarButtonItemStyleBordered
                                        target:self
                                        action:@selector(toggleLanguagePopover)];
    self.navigationItem.rightBarButtonItem = self.languageButton;
    [self configureView];
}

- (IBAction)toggleLanguagePopover
{
    if (self.languagePopoverController == nil) {
        BIDLanguageListController *languageListController =
        [[BIDLanguageListController alloc] init];
        languageListController.detailViewController = self;
        UIPopoverController *poc = [[UIPopoverController alloc]
                                    initWithContentViewController:languageListController];
        [poc presentPopoverFromBarButtonItem:self.languageButton
                    permittedArrowDirections:UIPopoverArrowDirectionAny
                                    animated:YES];
        self.languagePopoverController = poc;
    } else {
        if (self.languagePopoverController != nil) {
            [self.languagePopoverController dismissPopoverAnimated:YES];
            self.languagePopoverController = nil;
        }
    }
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Presidents", @"Presidents");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
