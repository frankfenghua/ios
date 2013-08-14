//
//  BIDHeaderCell.m
//  DialogViewer
//

#import "BIDHeaderCell.h"

@implementation BIDHeaderCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.label.backgroundColor = [UIColor yellowColor];
        self.label.textColor = [UIColor blackColor];
    }
    return self;
}

+ (UIFont *)defaultFont {
    return [UIFont systemFontOfSize:17];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
