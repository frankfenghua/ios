//
//  BIDViewController.h
//  LocalizeMe
//

#import <UIKit/UIKit.h>

@interface BIDViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *localeLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;

@end
