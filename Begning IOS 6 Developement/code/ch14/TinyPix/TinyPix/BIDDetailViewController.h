//
//  BIDDetailViewController.h
//  TinyPix
//

#import <UIKit/UIKit.h>

@class BIDTinyPixView;

@interface BIDDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet BIDTinyPixView *pixView;

@end
