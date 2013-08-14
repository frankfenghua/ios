//
//  BIDBallView.m
//  Ball
//

#import "BIDBallView.h"

@implementation BIDBallView

- (void)commonInit
{
    self.image = [UIImage imageNamed:@"ball.png"];
    self.currentPoint = CGPointMake((self.bounds.size.width / 2.0f) +
                                    (self.image.size.width / 2.0f),
                                    (self.bounds.size.height / 2.0f) + (self.image.size.height / 2.0f));
}

- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self.image drawAtPoint:self.currentPoint];
}

#pragma mark -

- (void)setCurrentPoint:(CGPoint)newPoint
{
    self.previousPoint = self.currentPoint;
    _currentPoint = newPoint;
    
/*    if (self.currentPoint.x < 0) {
        _currentPoint.x = 0;
        self.ballXVelocity = -self.ballXVelocity / 2;
    }
    if (self.currentPoint.y < 0){
        _currentPoint.y = 0;
        self.ballYVelocity = -self.ballYVelocity / 2;
    }
    if (self.currentPoint.x > self.bounds.size.width - self.image.size.width) {
        _currentPoint.x = self.bounds.size.width - self.image.size.width;
        self.ballXVelocity = -self.ballXVelocity / 2;
    }
    if (self.currentPoint.y > self.bounds.size.height - self.image.size.height) {
        _currentPoint.y = self.bounds.size.height - self.image.size.height;
        self.ballYVelocity = -self.ballYVelocity / 2;
    }*/
    if (self.currentPoint.x < 0) {
        _currentPoint.x = 0;
        self.ballXVelocity = 0;
    }
    if (self.currentPoint.y < 0){
        _currentPoint.y = 0;
        self.ballYVelocity = 0;
    }
    if (self.currentPoint.x > self.bounds.size.width - self.image.size.width) {
        _currentPoint.x = self.bounds.size.width - self.image.size.width;
        self.ballXVelocity = 0;
    }
    if (self.currentPoint.y > self.bounds.size.height - self.image.size.height) {
        _currentPoint.y = self.bounds.size.height - self.image.size.height;
        self.ballYVelocity = 0;
    }
    
    CGRect currentImageRect = CGRectMake(self.currentPoint.x, self.currentPoint.y,
                                         self.currentPoint.x + self.image.size.width,
                                         self.currentPoint.y + self.image.size.height);
    CGRect previousImageRect = CGRectMake(self.previousPoint.x, self.previousPoint.y,
                                          self.previousPoint.x + self.image.size.width,
                                          self.currentPoint.y + self.image.size.width);
    [self setNeedsDisplayInRect:CGRectUnion(currentImageRect,
                                            previousImageRect)];
}

- (void)update
{
    static NSDate *lastUpdateTime = nil;
    
    if (lastUpdateTime != nil) {
        NSTimeInterval secondsSinceLastDraw =
        -([lastUpdateTime timeIntervalSinceNow]);
        
        self.ballYVelocity = self.ballYVelocity -
                             (self.acceleration.y * secondsSinceLastDraw);
        self.ballXVelocity = self.ballXVelocity +
                             (self.acceleration.x * secondsSinceLastDraw);
        
        CGFloat xAcceleration = secondsSinceLastDraw * self.ballXVelocity * 500;
        CGFloat yAcceleration = secondsSinceLastDraw * self.ballYVelocity * 500;
        
        self.currentPoint = CGPointMake(self.currentPoint.x + xAcceleration,
                                        self.currentPoint.y + yAcceleration);
    }
    // Update last time with current time
    lastUpdateTime = [[NSDate alloc] init];
}

@end
