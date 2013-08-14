//
//  BIDGLFunView.m
//  GLFun
//

#import "BIDGLFunView.h"
#import "UIColor+BIDRandom.h"
#import "Texture2D.h"

@implementation BIDGLFunView

- (id)initWithCoder:(NSCoder*)coder {
    if (self = [super initWithCoder:coder]) {
        _currentColor = [UIColor redColor];
        _useRandomColor = NO;
        _sprite = [[Texture2D alloc] initWithImage:[UIImage
                                                   imageNamed:@"iphone.png"]];
        glBindTexture(GL_TEXTURE_2D, _sprite.name);
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)draw  {
    glLoadIdentity();
    
    glClearColor(0.78f, 0.78f, 0.78f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    CGColorRef color = _currentColor.CGColor;
    const CGFloat *components = CGColorGetComponents(color);
    CGFloat red = components[0];
    CGFloat green = components[1];
    CGFloat blue = components[2];
    
    glColor4f(red, green, blue, 1.0);
    switch (_shapeType) {
        case kLineShape: {
            glDisable(GL_TEXTURE_2D);
            GLfloat vertices[4];
            
            // Convert coordinates
            vertices[0] = _firstTouch.x;
            vertices[1] = self.frame.size.height - _firstTouch.y;
            vertices[2] = _lastTouch.x;
            vertices[3] = self.frame.size.height - _lastTouch.y;
            glLineWidth(2.0);
            glVertexPointer(2, GL_FLOAT, 0, vertices);
            glDrawArrays(GL_LINES, 0, 2);
            break;
        }
        case kRectShape: {
            glDisable(GL_TEXTURE_2D);
            // Calculate bounding rect and store in vertices
            GLfloat vertices[8];
            GLfloat minX = (_firstTouch.x > _lastTouch.x) ?
            _lastTouch.x : _firstTouch.x;
            GLfloat minY = (self.frame.size.height - _firstTouch.y >
                            self.frame.size.height - _lastTouch.y) ?
            self.frame.size.height - _lastTouch.y :
            self.frame.size.height - _firstTouch.y;
            GLfloat maxX = (_firstTouch.x > _lastTouch.x) ?
            _firstTouch.x : _lastTouch.x;
            GLfloat maxY = (self.frame.size.height - _firstTouch.y >
                            self.frame.size.height - _lastTouch.y) ?
            self.frame.size.height - _firstTouch.y :
            self.frame.size.height - _lastTouch.y;
            
            vertices[0] = maxX;
            vertices[1] = maxY;
            vertices[2] = minX;
            vertices[3] = maxY;
            vertices[4] = minX;
            vertices[5] = minY;
            vertices[6] = maxX;
            vertices[7] = minY;
            
            glVertexPointer(2, GL_FLOAT , 0, vertices);
            glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
            break;
        }
        case kEllipseShape: {
            glDisable(GL_TEXTURE_2D);
            GLfloat vertices[720];
            
            GLfloat xradius = fabsf((_firstTouch.x - _lastTouch.x) / 2);
            GLfloat yradius = fabsf((_firstTouch.y - _lastTouch.y) / 2);
            for (int i = 0; i <= 720; i += 2) {
                GLfloat xOffset = (_firstTouch.x > _lastTouch.x) ?
                _lastTouch.x + xradius : _firstTouch.x + xradius;
                GLfloat yOffset = (_firstTouch.y < _lastTouch.y) ?
                self.frame.size.height - _lastTouch.y + yradius :
                self.frame.size.height - _firstTouch.y + yradius;
                vertices[i] = (cos(degreesToRadian(i / 2)) * xradius) + xOffset;
                vertices[i+1] = (sin(degreesToRadian(i / 2)) * yradius) +
                yOffset;
            }
            
            glVertexPointer(2, GL_FLOAT , 0, vertices);
            glDrawArrays(GL_TRIANGLE_FAN, 0, 360);
            break;
        }
        case kImageShape:
            glEnable(GL_TEXTURE_2D);
            [_sprite drawAtPoint:CGPointMake(_lastTouch.x,
                                            self.frame.size.height - _lastTouch.y)];
            break;
        default:
            break;
    }
    
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_useRandomColor)
        self.currentColor = [UIColor randomColor];
    
    UITouch* touch = [[event touchesForView:self] anyObject];
    _firstTouch = [touch locationInView:self];
    _lastTouch = [touch locationInView:self];
    [self draw];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    _lastTouch = [touch locationInView:self];
    
    [self draw];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _lastTouch = [touch locationInView:self];
    
    [self draw];
}
@end
