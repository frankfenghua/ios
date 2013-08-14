//
//  BIDQuartzFunView.m
//  QuartzFun
//

#import "BIDQuartzFunView.h"
#import "UIColor+BIDRandom.h"

@implementation BIDQuartzFunView

- (CGRect)currentRect {
    return CGRectMake (_firstTouch.x,
                       _firstTouch.y,
                       _lastTouch.x - _firstTouch.x,
                       _lastTouch.y - _firstTouch.y);
}

- (id)initWithCoder:(NSCoder*)coder {
    if (self = [super initWithCoder:coder]) {
        _currentColor = [UIColor redColor];
        _useRandomColor = NO;
        _drawImage = [UIImage imageNamed:@"iphone.png"] ;
    }
    return self;
}

#pragma mark - Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_useRandomColor) {
        self.currentColor = [UIColor randomColor];
    }
    UITouch *touch = [touches anyObject];
    _firstTouch = [touch locationInView:self];
    _lastTouch = [touch locationInView:self];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _lastTouch = [touch locationInView:self];
    
    if (_shapeType == kImageShape) {
        CGFloat horizontalOffset = _drawImage.size.width / 2;
        CGFloat verticalOffset = _drawImage.size.height / 2;
        _redrawRect = CGRectUnion(_redrawRect,
                                 CGRectMake(_lastTouch.x - horizontalOffset,
                                            _lastTouch.y - verticalOffset,
                                            _drawImage.size.width,
                                            _drawImage.size.height));
    } else {
        _redrawRect = CGRectUnion(_redrawRect, self.currentRect);
    }
    _redrawRect = CGRectInset(_redrawRect, -2.0, -2.0);
    [self setNeedsDisplayInRect:_redrawRect];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _lastTouch = [touch locationInView:self];
    
    if (_shapeType == kImageShape) {
        CGFloat horizontalOffset = _drawImage.size.width / 2;
        CGFloat verticalOffset = _drawImage.size.height / 2;
        _redrawRect = CGRectUnion(_redrawRect,
                                 CGRectMake(_lastTouch.x - horizontalOffset,
                                            _lastTouch.y - verticalOffset,
                                            _drawImage.size.width,
                                            _drawImage.size.height));
    }
    _redrawRect = CGRectUnion(_redrawRect, self.currentRect);
    [self setNeedsDisplayInRect:_redrawRect];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, _currentColor.CGColor);
    
    CGContextSetFillColorWithColor(context, _currentColor.CGColor);
    
    switch (_shapeType) {
        case kLineShape:
            CGContextMoveToPoint(context, _firstTouch.x, _firstTouch.y);
            CGContextAddLineToPoint(context, _lastTouch.x, _lastTouch.y);
            CGContextStrokePath(context);
            break;
        case kRectShape:
            CGContextAddRect(context, self.currentRect);
            CGContextDrawPath(context, kCGPathFillStroke);
            break;
        case kEllipseShape:
            CGContextAddEllipseInRect(context, self.currentRect);
            CGContextDrawPath(context, kCGPathFillStroke);
            break;
        case kImageShape: {
            CGFloat horizontalOffset = _drawImage.size.width / 2;
            CGFloat verticalOffset = _drawImage.size.height / 2;
            CGPoint drawPoint = CGPointMake(_lastTouch.x - horizontalOffset,
                                            _lastTouch.y - verticalOffset);
            [_drawImage drawAtPoint:drawPoint];
            break;
        }
        default:
            break;
    }
}
@end
