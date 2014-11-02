//
//  DirectionAndDistance.m
//  MapsDirections
//
//  Created by Yuliia on 10/19/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import "DirectionAndDistance.h"
#import "MapViewController.h"



@interface DirectionAndDistance () <GMSMapViewDelegate, CLLocationManagerDelegate> {
    BOOL _sensor;
    BOOL _alternatives;
    NSURL *_directionsURL;
    NSDictionary *query;
    MapSingletone *mapSingletone;
    NSString *distanceToTappedMarker;
}
@end

@implementation DirectionAndDistance


+ (id)sharedManager {
    static DirectionAndDistance *sharedDistanceManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDistanceManager = [[DirectionAndDistance alloc] init];
        
    });
    
    return sharedDistanceManager;
}
- (id)init {
    
    if (self = [super init]) {
       
    }
    return self;
}


-(void)buildTheRouteAndSetTheDistance :(float)tappedMarkerLongtitude :(float)tappedMarkerLatitude :(void(^)(NSString* ,GMSPolyline*))completion {
    mapSingletone = [MapSingletone sharedManager];
    
    CLLocationCoordinate2D positionOfTappedMarker = CLLocationCoordinate2DMake (tappedMarkerLongtitude, tappedMarkerLatitude);
    GMSMarker *marker = [GMSMarker markerWithPosition:positionOfTappedMarker];
    [mapSingletone.waypoints_ addObject:marker];
    NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                tappedMarkerLatitude, tappedMarkerLongtitude];
    [mapSingletone.waypointStrings_ addObject:positionString];
    if([mapSingletone.waypoints_ count]>1) {          // when some is tapped
        NSString *sensor = @"true";
        NSArray *parameters = [NSArray arrayWithObjects:sensor, mapSingletone.waypointStrings_,
                               nil];
        NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
        query = [NSDictionary dictionaryWithObjects:parameters
                                            forKeys:keys];
        [self setDirectionsQuery:query :^(NSString *completion2, GMSPolyline *polylineInBlock){
             GMSPolyline *localPol;
            localPol = nil;
            distanceToTappedMarker = completion2;
            localPol = polylineInBlock;
            completion (distanceToTappedMarker, polylineInBlock);
        }];
    }
}

static NSString *kMDDirectionsURL = @"http://maps.googleapis.com/maps/api/directions/json?";
- (void)setDirectionsQuery:(NSDictionary *)queryForObtainingTheDirection :(void(^)(NSString* ,GMSPolyline*))completion2 {
    NSArray *waypoints = [queryForObtainingTheDirection objectForKey:@"waypoints"];
    NSString *origin = [waypoints objectAtIndex:0];
    NSString *destination = [waypoints objectAtIndex:1];
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
        NSString *distanceToTappedMarkerToPass = (NSString*)[parsedDistance objectForKey
                                             :@"text"];
        NSString *overview_route = [route objectForKey:@"points"];
        GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
        GMSPolyline *polyline2 = [GMSPolyline polylineWithPath:path];
        
//        mapSingletone.polyline.map = nil;
//        mapSingletone.polyline = polyline2;
//        mapSingletone.polyline.map = mapSingletone.mapView_;
        completion2 (distanceToTappedMarkerToPass, polyline2);
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
