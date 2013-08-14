//
//  BIDPlace
//  WhereAmI
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface BIDPlace : NSObject <MKAnnotation>

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;


@end
