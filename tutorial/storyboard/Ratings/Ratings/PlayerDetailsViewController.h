//
//  PlayerDetailsViewController.h
//  Ratings
//
//  Created by Marin Todorov on 9/9/13.
//
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import "GamePickerViewController.h"

@class PlayerDetailsViewController;

@protocol PlayerDetailsViewControllerDelegate <NSObject>
- (void)playerDetailsViewControllerDidCancel:
(PlayerDetailsViewController *)controller;
- (void)playerDetailsViewController:
(PlayerDetailsViewController *)controller
                       didAddPlayer:(Player *)player;
@end

@interface PlayerDetailsViewController : UITableViewController <GamePickerViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (nonatomic, weak) id <PlayerDetailsViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end