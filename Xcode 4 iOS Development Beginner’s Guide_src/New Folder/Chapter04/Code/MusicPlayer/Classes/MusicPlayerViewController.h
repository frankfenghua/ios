//
//  MusicPlayerViewController.h
//  MusicPlayer
//
//  Created by Steven F. Daniel on 1/12/10.
//  Copyright 2010 GENIESOFT STUDIOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>


@interface MusicPlayerViewController : UIViewController {
    AVAudioPlayer *player;
}

@property(nonatomic,retain) AVAudioPlayer *player;
@end
