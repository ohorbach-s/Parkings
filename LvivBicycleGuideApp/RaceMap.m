//
//  RaceViewController.m
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 11/13/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "RaceMap.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "RoutePoints.h"
#import "DirectionAndDistance.h"

@interface RaceMap (){
    
    CLLocationManager *locationManager;
    CLLocationCoordinate2D position;
    NSString *path;
    GMSMarker *startPoint;
    GMSMarker *endPoint;
    RoutePoints *routePoints;
    NSString *positionString;
    DirectionAndDistance *findTheDirection;
    NSMutableArray *arrayOfPolylines;
    NSMutableArray *arrayOfMarkers;
    NSMutableArray *arrayOfPathes;
    GMSPolyline *customPolyline;
    int count;
    GMSMarker *mark;
    NSString *str;
}

@property (unsafe_unretained, nonatomic) IBOutlet GMSMapView *mapView;
@end

@implementation RaceMap

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"greenbsck.png"]];
    routePoints = [RoutePoints sharedManager];
    findTheDirection = [DirectionAndDistance sharedManager];
    arrayOfPolylines = [[NSMutableArray alloc]init];
    arrayOfMarkers = [[NSMutableArray alloc]init];
    arrayOfPathes = [[NSMutableArray alloc] init];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    position = CLLocationCoordinate2DMake(49.837120,24.026780 );
    [self.mapView animateToLocation:position];
    [self.mapView animateToZoom:13.384848];
    _mapView.delegate = self;
    _mapView.myLocationEnabled= YES;
    _mapView.settings.myLocationButton = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated
{
    [routePoints.customWayPoints removeAllObjects];
    [routePoints.customWaypointStrings removeAllObjects];
    [arrayOfPolylines removeAllObjects];
    [self.mapView clear];
}

- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    count = 0;
    GMSMarker* firstPosition = [arrayOfMarkers firstObject];
     GMSMarker* lastPosition = [arrayOfMarkers lastObject];
    [self.pathDelegate setPath:arrayOfPathes :firstPosition andEndPosition:lastPosition];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clearButtonPressed:(UIBarButtonItem *)sender {
    static int countClear = 0;
    countClear ++;
    if (countClear <2) {
        [routePoints.customWayPoints removeObject:[routePoints.customWayPoints lastObject]];
        [routePoints.customWaypointStrings removeObject:[routePoints.customWaypointStrings lastObject]];
        ((GMSPolyline*)[arrayOfPolylines lastObject]).map = nil;
        [arrayOfPolylines removeObject:[arrayOfPolylines lastObject]];
        ((GMSMarker*)[arrayOfMarkers lastObject]).map = nil;
        [arrayOfMarkers removeObject:[arrayOfMarkers lastObject]];
        [arrayOfPathes removeObject:[arrayOfPathes lastObject]];
        if (![arrayOfMarkers count]) {
            count = 0;
        }
        [routePoints.customWayPoints removeAllObjects];
        [routePoints.customWaypointStrings removeAllObjects];
        [routePoints.customWayPoints addObject:mark];
        [routePoints.customWaypointStrings addObject:str];
    } else {
    [routePoints.customWayPoints removeAllObjects];
        [routePoints.customWaypointStrings removeAllObjects];
        [arrayOfMarkers removeAllObjects];
        [arrayOfPolylines removeAllObjects];
        [arrayOfPathes removeAllObjects];
        [self.mapView clear];
        count = 0;
        countClear = 0;
    }
}
-(void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
        if (count == 0) {
             startPoint = [GMSMarker markerWithPosition:coordinate];
            [routePoints.customWayPoints addObject:startPoint];
            positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                              coordinate.latitude, coordinate.longitude];
            [routePoints.customWaypointStrings addObject:positionString];
            [arrayOfMarkers addObject:startPoint];
              startPoint.map = _mapView;
        }
        if (count > 0) {
            endPoint = [GMSMarker markerWithPosition:coordinate];
            [arrayOfMarkers addObject:endPoint];
            [routePoints.customWayPoints addObject:endPoint];
            positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                              coordinate.latitude, coordinate.longitude];
            [routePoints.customWaypointStrings addObject:positionString];
            endPoint.map = _mapView;
            [findTheDirection findCustomRouteWithCompletionHandler:^(NSString *distance, GMSPolyline *polylineFromBlock, NSString *pathFromBlock){
                customPolyline = polylineFromBlock;
                customPolyline.strokeColor =[UIColor colorWithRed:255/255.0f green:161/255.0f blue:4/255.0f alpha:1.0f];
                customPolyline.strokeWidth = 2.0f;
                customPolyline.map = _mapView;
                customPolyline.tappable = YES;
                [arrayOfPolylines addObject:customPolyline];
                [arrayOfPathes addObject:pathFromBlock];
            }];
             startPoint = endPoint;
        }
        count++;
        if (count > 1) {
            mark = [routePoints.customWayPoints objectAtIndex:0];
            str  = [routePoints.customWaypointStrings objectAtIndex:0];
            [routePoints.customWayPoints removeObjectAtIndex:0];
            [routePoints.customWaypointStrings removeObjectAtIndex:0];
        }
}

@end
