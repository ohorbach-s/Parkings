//
//  DirectionAndDistance.h
//  MapsDirections
//
//  Created by Yuliia on 10/19/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "RoutePoints.h"

@interface DirectionAndDistance : NSObject

-(void)buildTheRouteAndSetTheDistanceForLongitude :(float)tappedMarkerLongtitude AndLatitude:(float)tappedMarkerLatitude WithCompletionHandler:(void(^)(NSString* ,GMSPolyline*))completion;
- (void)setDirectionsQuery:(NSDictionary *)queryForObtainingTheDirection :(void(^)(NSString* ,GMSPolyline*))completion2;
- (void)retrieveDirectionsWithCompletionHandler :(void(^)(NSDictionary* ))completionHandler;
-(void)findCustomRouteWithCompletionHandler:(void(^)(NSString* ,GMSPolyline*))completion;
+ (id)sharedManager;

@end
