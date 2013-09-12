//
//  RockPaperScissorsView.m
//  Sample 1
//
//  Created by Lucas Jordan on 9/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RockPaperScissorsView.h"

@implementation RockPaperScissorsView


-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        srand(time(NULL));
        
        CGSize size = CGSizeMake(300, 300);
        
        buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [buttonView setBackgroundColor:[UIColor lightGrayColor]];
        [self addSubview:buttonView];
        
        float sixtyPercent = size.width * .6;
        float twentyPercent = size.width * .2;
        float twentFivePercent = size.height/4;
        float thirtyThreePercent = size.height/3;
        
        rockButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [rockButton setFrame:CGRectMake(twentyPercent, twentFivePercent, sixtyPercent, 40)];
        [rockButton setTitle:@"Rock" forState:UIControlStateNormal];
        [rockButton addTarget:self action:@selector(userSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        paperButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [paperButton setFrame:CGRectMake(twentyPercent, twentFivePercent*2, sixtyPercent, 40)];
        [paperButton setTitle:@"Paper" forState:UIControlStateNormal];
        [paperButton addTarget:self action:@selector(userSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        scissorsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [scissorsButton setFrame:CGRectMake(twentyPercent, twentFivePercent*3, sixtyPercent, 40)];
        [scissorsButton setTitle:@"Scissors" forState:UIControlStateNormal];
        [scissorsButton addTarget:self action:@selector(userSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [buttonView addSubview:rockButton];
        [buttonView addSubview:paperButton];
        [buttonView addSubview:scissorsButton];
        
        
        resultView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [resultView setBackgroundColor:[UIColor lightGrayColor]];
        
        resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(twentyPercent, thirtyThreePercent, sixtyPercent, 40)];
        [resultLabel setBackgroundColor: [UIColor whiteColor]];
        [resultLabel setAdjustsFontSizeToFitWidth:YES];
        [resultView addSubview: resultLabel];
        
        continueButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [continueButton setFrame:CGRectMake(twentyPercent, thirtyThreePercent*2, sixtyPercent, 40)];
        [continueButton setTitle:@"Continue" forState:UIControlStateNormal];
        [continueButton addTarget:self action:@selector(continueGame:) forControlEvents:UIControlEventTouchUpInside];
        [resultView addSubview:continueButton];
        
        
    }
    return self;
}

-(void)userSelected:(id)sender{
	int result = random()%3;
	
	UIButton* selectedButton = (UIButton*)sender;
	NSString* selection = [[selectedButton titleLabel] text];
	
	NSString* resultText;
	if (result == 0){//lost
		NSString* computerSelection = [self getLostTo:selection];
		resultText = [@"Lost, iOS selected " stringByAppendingString: computerSelection];
	} else if (result == 1) {//tie
		resultText = [@"Tie, iOS selected " stringByAppendingString: selection];
	} else {//win
		NSString* computerSelection = [self getWonTo:selection];
		resultText = [@"Won, iOS selected " stringByAppendingString: computerSelection];
	}
	
	[resultLabel setText:resultText];
	
	[buttonView removeFromSuperview];
	[self addSubview:resultView];
    
}
-(void)continueGame:(id)sender{
	[resultView removeFromSuperview];
	[self addSubview:buttonView];
}

-(NSString*)getLostTo:(NSString*)selection{
	if ([selection isEqual:@"Rock"]){
		return @"Paper";
	} else if ([selection isEqual:@"Paper"]){
		return @"Scissors";
	} else {
		return @"Rock";
	}
}
-(NSString*)getWonTo:(NSString*)selection{
	if ([selection isEqual:@"Rock"]){
		return @"Scissors";
	} else if ([selection isEqual:@"Paper"]){
		return @"Rock";
	} else {
		return @"Paper";
	}
}


@end
