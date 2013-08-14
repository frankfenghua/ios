//
//  BIDBallView.h
//  Ball
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface BIDBallView : UIView

@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) CGPoint currentPoint;
@property (assign, nonatomic) CGPoint previousPoint;
@property (assign, nonatomic) CMAcceleration acceleration;
@property (assign, nonatomic) CGFloat ballXVelocity;
@property (assign, nonatomic) CGFloat ballYVelocity;

@end
