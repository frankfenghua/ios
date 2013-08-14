//
//  BIDTinyPixDocument.h
//  TinyPix
//

#import <UIKit/UIKit.h>

@interface BIDTinyPixDocument : UIDocument

// row and column range from 0 to 7
- (BOOL)stateAtRow:(NSUInteger)row column:(NSUInteger)column;
- (void)setState:(BOOL)state atRow:(NSUInteger)row column:(NSUInteger)column;
- (void)toggleStateAtRow:(NSUInteger)row column:(NSUInteger)column;

@end
