//
//  BIDViewController.h
//  WhereAmI
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface BIDViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *startPoint;
@property (assign, nonatomic) CLLocationDistance totalDistance;
@property (strong, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *horizontalAccuracyLabel;
@property (strong, nonatomic) IBOutlet UILabel *altitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *verticalAccuracyLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceTraveledLabel;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
