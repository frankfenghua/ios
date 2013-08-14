//
//  BIDContentCell.h
//  DialogViewer
//

#import <UIKit/UIKit.h>

@interface BIDContentCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *label;
@property (copy, nonatomic) NSString *text;

+ (CGSize)sizeForContentString:(NSString *)s;

@end
