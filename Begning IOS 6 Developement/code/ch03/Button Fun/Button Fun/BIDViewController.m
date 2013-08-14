//
//  BIDViewController.m
//  Button Fun
//

#import "BIDViewController.h"

@implementation BIDViewController
@synthesize statusLabel;

- (IBAction)buttonPressed:(UIButton *)sender {
    NSString *title = [sender titleForState:UIControlStateNormal];
    NSString *plainText = [NSString stringWithFormat:@"%@ button pressed.", title];
//    statusLabel.text = plainText;

    NSMutableAttributedString *styledText = [[NSMutableAttributedString alloc]
                                             initWithString:plainText];
    
    NSDictionary *attributes = @{
    NSFontAttributeName : [UIFont boldSystemFontOfSize:statusLabel.font.pointSize]
    };

    NSRange nameRange = [plainText rangeOfString:title];
    
    [styledText setAttributes:attributes
                        range:nameRange];
    statusLabel.attributedText = styledText;
}
@end
