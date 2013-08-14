//
//  BIDTinyPixView.h
//  TinyPix
//

#import <UIKit/UIKit.h>
@class BIDTinyPixDocument;

@interface BIDTinyPixView : UIView

@property (strong, nonatomic) BIDTinyPixDocument *document;
@property (strong, nonatomic) UIColor *highlightColor;

@end
