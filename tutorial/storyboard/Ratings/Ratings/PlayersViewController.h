//
//  PlayersViewController.h
//  Ratings
//
//  Created by Marin Todorov on 8/9/13.
//
//

#import <UIKit/UIKit.h>
#import "PlayerDetailsViewController.h"

@interface PlayersViewController : UITableViewController<PlayerDetailsViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray *players;
@end
