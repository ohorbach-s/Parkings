#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol GClusterItem <NSObject>

@property (nonatomic, assign, readonly) CLLocationCoordinate2D position;
@property (nonatomic, strong, readonly) UIImage *icon;

@end
