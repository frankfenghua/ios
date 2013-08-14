//
//  BIDDisclosureDetailViewController.m
//  Nav
//

#import "BIDDisclosureDetailViewController.h"

@implementation BIDDisclosureDetailViewController

- (UILabel *)label;
{
    return (id)self.view;
}

- (void)loadView;
{
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    self.view = label;
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    self.label.text = self.message;
}

@end
