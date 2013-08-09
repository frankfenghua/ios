//
//  CoreLocationViewController.h
//  CoreLocation
//
//  Created by Steven F Daniel on 3/12/10.
//  Copyright 2010 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CoreLocationViewController : UIViewController <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    UILabel *lblLocation;
}
@property (nonatomic, retain) IBOutlet UILabel *lblLocation;

@end
