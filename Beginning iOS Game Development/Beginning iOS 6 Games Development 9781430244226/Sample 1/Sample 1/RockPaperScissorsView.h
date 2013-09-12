//
//  RockPaperScissorsView.h
//  Sample 1
//
//  Created by Lucas Jordan on 9/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RockPaperScissorsView : UIView{
    UIView* buttonView;
	UIButton* rockButton;
	UIButton* paperButton;
	UIButton* scissorsButton;
	
	UIView* resultView;
	UILabel* resultLabel;
	UIButton* continueButton;
}
-(void)userSelected:(id)sender;
-(void)continueGame:(id)sender;
-(NSString*)getLostTo:(NSString*)selection;
-(NSString*)getWonTo:(NSString*)selection;
@end
