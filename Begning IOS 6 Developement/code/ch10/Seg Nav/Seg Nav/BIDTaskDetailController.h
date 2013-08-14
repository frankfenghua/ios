//
//  BIDTaskDetailController.h
//  Seg Nav
//

#import <UIKit/UIKit.h>

@interface BIDTaskDetailController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (copy, nonatomic) NSDictionary *selection;
@property (weak, nonatomic) id delegate;

@end
