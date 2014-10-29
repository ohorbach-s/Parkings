//
//  MapViewController.m
//  LvivBicycleGuideApp
//
//  Created by Alexxx on 10/17/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "MapViewController.h"
#import "DirectionAndDistance.h"
#import "SWRevealViewController.h"
#import "GClusterManager.h"
#import "NonHierarchicalDistanceBasedAlgorithm.h"
#import "GDefaultClusterRenderer.h"


GMSMarker *myMarker;
NSString *iconOfSelectedMarker;
GClusterManager *clusterManager;

@interface MapViewController () {
    
    CLLocationCoordinate2D position;    //   for temporary markers}
    GMSMarker *alreadyTappedMarker;
    DirectionAndDistance *findTheDirection;
     GMSCameraPosition *previousCameraPosition_;
    SlideMenuViewController *menuObject;
    StorageClass *storage;
    RequestsClass *requestToDisplay;
    MapSingletone *mapSingletone;
    int trackTapps;
}

@end

static NSString *kMDDirectionsURL = @"http://maps.googleapis.com/maps/api/directions/json?";

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    storage = [StorageClass sharedManager];
    mapSingletone = [MapSingletone sharedManager];
    requestToDisplay = [[RequestsClass alloc] init];
    findTheDirection = [DirectionAndDistance new];
    menuObject = [[SlideMenuViewController alloc] init];
    [self firstMapLaunch];
    clusterManager = [GClusterManager managerWithMapView:mapSingletone.mapView_
                                               algorithm:[[NonHierarchicalDistanceBasedAlgorithm alloc] init]
                                                renderer:[[GDefaultClusterRenderer alloc] initWithMapView:mapSingletone.mapView_]];
    [RequestsClass firstLoad];
    trackTapps = 0;
    iconOfSelectedMarker = @"parking.png";
    [requestToDisplay displayObjectsMarkers:@"Parking" :iconOfSelectedMarker];
    [self setAppearance];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSelectedCategory:) name:@"setSelectedCategory" object:nil];
    //hide detailInfo views
    [_detailSubviewObject setHidden:YES];
    [_bigDetailPanel setHidden:YES];
}

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)cameraPosition
{
    assert(mapView == _mapView);
    // Don't re-compute clusters if the map has just been panned/tilted/rotated.
    GMSCameraPosition *currentPosition = [mapView camera];
    if (previousCameraPosition_ != nil && previousCameraPosition_.zoom == currentPosition.zoom) {
        return;
    }
    previousCameraPosition_ = [mapView camera];
    [clusterManager cluster];
}

-(void)setSelectedCategory : (NSNotification *)notification
{
    [menuObject setIndexValueWithCompletion:^(NSInteger indexValue){
        self.navigationController.navigationBar.topItem.title = storage.pickerData[indexValue];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    mapSingletone.polyline.map = mapSingletone.mapView_;
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [_detailSubviewObject setHidden:YES];
    [_bigDetailPanel setHidden:YES];

}

-(BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    if ([marker isEqual:alreadyTappedMarker]&&(trackTapps>0)) {
        mapSingletone.polyline.map = nil;
        mapSingletone.polyline = nil;
        trackTapps --;
        return YES;
    } else if ([marker isEqual:alreadyTappedMarker]) {
        mapSingletone.polyline = nil;
        return YES;
    } else {
        trackTapps ++;
        mapSingletone.polyline.map = nil;
        position = CLLocationCoordinate2DMake(marker.position.longitude,marker.position.latitude);        
        [storage.detailInfoForObject setDetailInfoForTappedMarker:position];
        self.detailSubviewObject.distanceLabel.text= @"";
        [self.detailSubviewObject setDetail:storage.detailInfoForObject.name :marker.position.longitude :marker.position.latitude];
        [_detailSubviewObject setHidden:NO];
        return YES;
    }
}
- (IBAction)pressButtonMenu:(id)sender
{
    [self.revealViewController revealToggle:sender];
    [_bigDetailPanel setHidden:YES];
    [_detailSubviewObject setHidden:YES];
}
- (IBAction)pressSmallInfoButton:(id)sender
{
    [_bigDetailPanel setDataOfWindow];
    [_detailSubviewObject setHidden:YES];
    [_bigDetailPanel setHidden:NO];
}

-(void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [_detailSubviewObject setHidden:YES];
    [_bigDetailPanel setHidden:YES];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    [mapSingletone.mapView_ animateToLocation:currentLocation.coordinate];
    [_locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)firstMapLaunch
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    position = CLLocationCoordinate2DMake(49.8327176,23.9970189);
    GMSCameraPosition *camera=[GMSCameraPosition cameraWithTarget:position zoom:13];
    mapSingletone.mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    _mapView.delegate = self;
    mapSingletone.mapView_ = self.mapView;
    [mapSingletone.mapView_ animateToLocation:position];
    [mapSingletone.mapView_ animateToZoom:13];
    mapSingletone.mapView_.myLocationEnabled= YES;
      mapSingletone.mapView_.settings.myLocationButton = YES;
    GMSMarker *marker = [GMSMarker markerWithPosition:position];  //my location
    alreadyTappedMarker = marker;
    myMarker = marker;
    marker.icon = [UIImage imageNamed:@"home.png"];
    marker.map = mapSingletone.mapView_;
    [mapSingletone.waypoints_ addObject:marker];
    mapSingletone.positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                    marker.position.latitude,marker.position.longitude];
    [mapSingletone.waypointStrings_ addObject:mapSingletone.positionString];
}


-(void)setAppearance
{
    self.tabBarController.tabBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    self.tabBarController.tabBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.navigationController.navigationBar.topItem.title =  storage.pickerData[0];
    _detailSubviewObject.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    //set up smallview
    _detailSubviewObject.translucentAlpha = 0.9;
    _detailSubviewObject.translucentStyle = UIBarStyleBlack;
    _detailSubviewObject.translucentTintColor = [UIColor clearColor];
    //set up bigview
    _bigDetailPanel.translucentAlpha = 0.9;
    _bigDetailPanel.translucentStyle = UIBarStyleBlack;
    _bigDetailPanel.translucentTintColor = [UIColor clearColor];
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
