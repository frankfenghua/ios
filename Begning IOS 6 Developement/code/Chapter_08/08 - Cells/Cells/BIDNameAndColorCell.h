//
//  BIDNameAndColorCell.h
//  Cells
//

#import <UIKit/UIKit.h>

@interface BIDNameAndColorCell : UITableViewCell

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *color;

@property (strong, nonatomic) IBOutlet UILabel *nameValue;
@property (strong, nonatomic) IBOutlet UILabel *colorValue;

@end
