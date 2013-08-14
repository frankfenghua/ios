//
//  BIDViewController.h
//  TouchExplorer
//

#import <UIKit/UIKit.h>

@interface BIDViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *tapsLabel;
@property (weak, nonatomic) IBOutlet UILabel *touchesLabel;

- (void)updateLabelsFromTouches:(NSSet *)touches;

@end
