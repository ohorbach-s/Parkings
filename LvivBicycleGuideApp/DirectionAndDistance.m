//
//  DirectionAndDistance.m
//  MapsDirections
//
//  Created by Yuliia on 10/19/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import "DirectionAndDistance.h"
#import "MapViewController.h"

@interface DirectionAndDistance () <GMSMapViewDelegate, CLLocationManagerDelegate>
{
    BOOL _sensor;
    BOOL _alternatives;
    NSURL *_directionsURL;
    NSDictionary *query;
    RoutePoints *routePoints;
    NSString *distanceToTappedMarker;
}
@end

@implementation DirectionAndDistance

+ (id)sharedManager
{
    static DirectionAndDistance *sharedDistanceManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDistanceManager = [[DirectionAndDistance alloc] init];
        
    });
    return sharedDistanceManager;
}

- (id)init
{
    if (self = [super init]) {
        
    }
    return self;
}
//creating the query
-(void)buildTheRouteAndSetTheDistanceForLongitude:(float)tappedMarkerLongtitude
                                      AndLatitude:(float)tappedMarkerLatitude
                            WithCompletionHandler:(void(^)(NSString* ,GMSPolyline*))completion
{
    routePoints = [RoutePoints sharedManager];
    CLLocationCoordinate2D positionOfTappedMarker = CLLocationCoordinate2DMake (tappedMarkerLongtitude, tappedMarkerLatitude);
    GMSMarker *marker = [GMSMarker markerWithPosition:positionOfTappedMarker];
    [routePoints.waypoints_ addObject:marker];
    NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                tappedMarkerLatitude, tappedMarkerLongtitude];
    [routePoints.waypointStrings_ addObject:positionString];
    if([routePoints.waypoints_ count]>1) {          // when some is tapped
        NSString *sensor = @"true";
        NSArray *parameters = [NSArray arrayWithObjects:sensor, routePoints.waypointStrings_,
                               nil];
        NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
        query = [NSDictionary dictionaryWithObjects:parameters
                                            forKeys:keys];
        [self setDirectionsQuery:query WithCompletionHandler:^(NSString *completion2, GMSPolyline *polylineInBlock){
            completion (completion2, polylineInBlock);
        }];
    }
}
//passing the query to api and processing the response
static NSString *kMDDirectionsURL = @"http://maps.googleapis.com/maps/api/directions/json?";
- (void)setDirectionsQuery:(NSDictionary *)queryForObtainingTheDirection WithCompletionHandler:(void(^)(NSString* ,GMSPolyline*))completion2
{
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
        completion2 (distanceToTappedMarkerToPass, polyline2);
    }];
}
//getting the response
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

-(void)findCustomRouteWithCompletionHandler:(void(^)(NSString* ,GMSPolyline*))completion
{
    
    routePoints = [RoutePoints sharedManager];
    NSString *sensor = @"true";
    NSArray *parameters = [NSArray arrayWithObjects:sensor, routePoints.customWaypointStrings,
                           nil];
    NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
    query = [NSDictionary dictionaryWithObjects:parameters
                                        forKeys:keys];
    [self setDirectionsQuery:query WithCompletionHandler:^(NSString *completion2, GMSPolyline *polylineInBlock){
        completion (nil, polylineInBlock);
    }];
    
    
}

@end
