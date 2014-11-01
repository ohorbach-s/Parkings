//
//  DirectionAndDistance.m
//  MapsDirections
//
//  Created by Yuliia on 10/19/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import "DirectionAndDistance.h"
extern GMSMapView *mapView_;
extern NSMutableArray *waypoints_;
extern NSMutableArray *waypointStrings_;
extern NSArray *_waypoints;
extern NSString *positionString;
extern NSString *distanceToTappedMarker;
extern GMSPolyline *polyline;

@interface DirectionAndDistance () <GMSMapViewDelegate, CLLocationManagerDelegate> {
    BOOL _sensor;
    BOOL _alternatives;
    NSURL *_directionsURL;
    NSDictionary *query;
}
@end

@implementation DirectionAndDistance

-(void)buildTheRouteAndSetTheDistance :(float)tappedMarkerLongtitude :(float)tappedMarkerLatitude {
    CLLocationCoordinate2D positionOfTappedMarker = CLLocationCoordinate2DMake (tappedMarkerLongtitude, tappedMarkerLatitude);
    GMSMarker *marker = [GMSMarker markerWithPosition:positionOfTappedMarker];
    [waypoints_ addObject:marker];
    NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                tappedMarkerLatitude, tappedMarkerLongtitude];
    [waypointStrings_ addObject:positionString];
    if([waypoints_ count]>1) {          // when some is tapped
        NSString *sensor = @"true";
        NSArray *parameters = [NSArray arrayWithObjects:sensor, waypointStrings_,
                               nil];
        NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
        query = [NSDictionary dictionaryWithObjects:parameters
                                                          forKeys:keys];
        [self setDirectionsQuery:query];
        NSLog(@"%lu", (unsigned long)[waypoints_ count]);
}
}

static NSString *kMDDirectionsURL = @"http://maps.googleapis.com/maps/api/directions/json?";
- (void)setDirectionsQuery:(NSDictionary *)queryForObtainingTheDirection {
    NSArray *waypoints = [queryForObtainingTheDirection objectForKey:@"waypoints"];
    NSString *origin = [waypoints objectAtIndex:0];
    NSString *destination = [waypoints objectAtIndex:1];//destinationPos];
    NSString *sensor = [query objectForKey:@"sensor"];
    NSMutableString *url =
    [NSMutableString stringWithFormat:@"%@&origin=%@&destination=%@&sensor=%@",
    kMDDirectionsURL,origin,destination, sensor];
    url = [url
           stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    _directionsURL = [NSURL URLWithString:url];
    [self retrieveDirectionsWithCompletionHandler:^(NSDictionary* json2) {
        NSDictionary *routes = [json2 objectForKey:@"routes"][0];
        NSDictionary *route = [routes objectForKey:@"overview_polyline"];
        NSDictionary *parsedDistance =[[routes objectForKey
                                        :@"legs"][0]objectForKey:@"distance"];
        distanceToTappedMarker = (NSString*)[parsedDistance objectForKey
                                             :@"text"];
        NSLog(@"%@", distanceToTappedMarker);
        NSString *overview_route = [route objectForKey:@"points"];
        GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
        GMSPolyline *polyline2 = [GMSPolyline polylineWithPath:path];
        polyline.map = nil;
        polyline = polyline2;
        polyline.map = mapView_;
    }];
}
- (void)retrieveDirectionsWithCompletionHandler :(void(^)(NSDictionary*))completionHandler{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData* data =
        [NSData dataWithContentsOfURL:_directionsURL];
        NSError* error;
        NSDictionary *json = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:&error];
        completionHandler(json);
    });
}



@end
