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
#import "MapSingletone.h"

@interface DirectionAndDistance : NSObject

-(void)buildTheRouteAndSetTheDistance :(float)tappedMarkerLongtitude :(float)tappedMarkerLatitude :(void(^)(NSString*))completion ;
- (void)setDirectionsQuery:(NSDictionary *)queryForObtainingTheDirection :(void(^)(NSString*))completion2 ;
- (void)retrieveDirectionsWithCompletionHandler :(void(^)(NSDictionary* ))completionHandler;
+ (id)sharedManager;
@end
