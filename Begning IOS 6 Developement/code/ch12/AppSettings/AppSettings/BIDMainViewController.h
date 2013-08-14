//
//  BIDMainViewController.h
//  AppSettings
//

#import "BIDFlipsideViewController.h"

#define kUsernameKey        @"username"
#define kPasswordKey        @"password"
#define kProtocolKey        @"protocol"
#define kWarpDriveKey       @"warp"
#define kWarpFactorKey      @"warpFactor"
#define kFavoriteTeaKey     @"favoriteTea"
#define kFavoriteCandyKey   @"favoriteCandy"
#define kFavoriteGameKey    @"favoriteGame"
#define kFavoriteExcuseKey  @"favoriteExcuse"
#define kFavoriteSinKey     @"favoriteSin"

@interface BIDMainViewController : UIViewController <BIDFlipsideViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *protocolLabel;
@property (weak, nonatomic) IBOutlet UILabel *warpDriveLabel;
@property (weak, nonatomic) IBOutlet UILabel *warpFactorLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteTeaLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCandyLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteGameLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteExcuseLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteSinLabel;

- (void)refreshFields;

@end
