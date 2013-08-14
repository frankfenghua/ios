//
//  ViewController.m
//  QuartzFun
//

#import "ViewController.h"
#import "BIDConstants.h"
#import "BIDGLFunView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeColor:(id)sender {
    UISegmentedControl *control = sender;
    NSInteger index = [control selectedSegmentIndex];
    
    BIDGLFunView *funView = (BIDGLFunView *)self.view;
    
    switch (index) {
        case kRedColorTab:
            funView.currentColor = [UIColor redColor];
            funView.useRandomColor = NO;
            break;
        case kBlueColorTab:
            funView.currentColor = [UIColor blueColor];
            funView.useRandomColor = NO;
            break;
        case kYellowColorTab:
            funView.currentColor = [UIColor yellowColor];
            funView.useRandomColor = NO;
            break;
        case kGreenColorTab:
            funView.currentColor = [UIColor greenColor];
            funView.useRandomColor = NO;
            break;
        case kRandomColorTab:
            funView.useRandomColor = YES;
            break;
        default:
            break;
    }
}

- (IBAction)changeShape:(id)sender {
    UISegmentedControl *control = sender;
    [(BIDGLFunView *)self.view setShapeType:[control
                                                 selectedSegmentIndex]];
    
    if ([control selectedSegmentIndex] == kImageShape)
        _colorControl.hidden = YES;
    else
        _colorControl.hidden = NO;
}
@end
