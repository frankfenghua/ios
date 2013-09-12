//
//  RockPaperScissorsController.h
//  Sample 02
//
//  Created by Lucas Jordan on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RockPaperScissorsController : UIViewController {
    UIView* buttonView;
	UIButton* rockButton;
	UIButton* paperButton;
	UIButton* scissersButton;
	
	UIView* resultView;
	UILabel* resultLabel;
	UIButton* continueButton;
    
    BOOL isSetup;
}
-(void)setup:(CGSize)size;
-(void)userSelected:(id)sender;
-(void)continueGame:(id)sender;

-(NSString*)getLostTo:(NSString*)selection;
-(NSString*)getWonTo:(NSString*)selection;
@end
