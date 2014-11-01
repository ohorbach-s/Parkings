////


////  MapViewController.m
////  LvivBicycleGuideApp
////
////  Created by Alexxx on 10/17/14.
////  Copyright (c) 2014 SoftServe. All rights reserved.
////
//
#import "MapViewController.h"

#import <CoreLocation/CoreLocation.h>
#import "SmallDetaiPanel.h"
//#import "SlideMenuViewController.h"
#import "PlaceCategory.h"
#import "MapSingletone.h"
#import "Spot.h"
#import "GClusterManager.h"
#import "DataModel.h"
#import "BigDetailPanel.h"
#import "DirectionAndDistance.h"
#import "SWRevealViewController.h"
#import "NonHierarchicalDistanceBasedAlgorithm.h"
#import "GDefaultClusterRenderer.h"
#import "RNFrostedSidebar.h"

NSString *iconOfSelectedMarker;
GMSMarker *myMarker;

@interface MapViewController () {
    
CLLocationCoordinate2D position;
//SlideMenuViewController *menuObject;
    GMSMarker *alreadyTappedMarker;
    PlaceCategory *storage;
    DataModel *dataModel;
    DirectionAndDistance *findTheDirection;
    MapSingletone *mapSingletone;
     GMSCameraPosition *previousCameraPosition_;
    GClusterManager *clusterManager;
     NSString *category;
    RNFrostedSidebar *sideBluredMenu;
}


@end

    static NSString *kMDDirectionsURL = @"http://maps.googleapis.com/maps/api/directions/json?";

@implementation MapViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    storage = [PlaceCategory sharedManager];
    mapSingletone = [MapSingletone sharedManager];
    iconOfSelectedMarker = @"parking.png";
    dataModel = [DataModel sharedModel];
    findTheDirection = [DirectionAndDistance new];
    //    menuObject = [[SlideMenuViewController alloc] init];
   
    //init sideBluredMenu
    NSArray *images = @[
                        [UIImage imageNamed:@"parking.png"],
                        [UIImage imageNamed:@"tools.png"],
                        [UIImage imageNamed:@"cafe.png"],
                        [UIImage imageNamed:@"supermarket.png"]
                        ];
    
    sideBluredMenu = [[RNFrostedSidebar alloc] initWithImages:images];
    sideBluredMenu.delegate = self;
    
    
    [self firstMapLaunch];
    clusterManager = [GClusterManager managerWithMapView:mapSingletone.mapView_ algorithm:[[NonHierarchicalDistanceBasedAlgorithm alloc] init]
                                                                      renderer:[[GDefaultClusterRenderer alloc] initWithMapView:mapSingletone.mapView_]];
    
                      [self displayInitialObjectsMarkers];
                      [self setAppearance];
                      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSelectedCategory:) name:@"setSelectedCategory" object:nil];
                      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(renewMyMap:) name:@"performMapRenew" object:nil];
                      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fillSubview:) name:@"fillSubviewOfMap" object:nil];
                      [_detailSubviewObject setHidden:YES];
                      [_bigDetailPanel setHidden:YES];

}



//-(void)renewMyMap :(NSNotification*)notification
//{
//    [clusterManager removeItems];
//    [dataModel performFilterRenew :category];
//    [self displayInitialObjectsMarkers];
//}


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
    
    //[menuObject setIndexValueWithCompletion:^(NSInteger indexValue){
    //self.navigationController.navigationBar.topItem.title = iconOfSelectedMarker;
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

    if ([marker isEqual:alreadyTappedMarker]) {
               return YES;
            } else {
                mapSingletone.polyline.map = nil;
                position = marker.position;
                self.detailSubviewObject.distanceLabel.text= @"";
                [_detailSubviewObject setHidden:NO];
                [dataModel setMarkerForInfo:marker];
                return YES;
            } 
}

- (IBAction)pressButtonMenu:(id)sender
{
    [sideBluredMenu show];
    [_bigDetailPanel setHidden:YES];
    [_detailSubviewObject setHidden:YES];
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index
{
    self.navigationController.navigationBar.topItem.title = storage.categoryNamesArray[index];
    iconOfSelectedMarker = storage.markersImages[index];
    category = storage.categoryNamesArray[index];
    [sidebar dismissAnimated:YES completion:nil];
    [clusterManager removeItems];
    [dataModel performFilterRenew :category];
    [self displayInitialObjectsMarkers];

}
- (void)sidebar:(RNFrostedSidebar *)sidebar willDismissFromScreenAnimated:(BOOL)animatedYesOrNo
{}

- (IBAction)pressSmallInfoButton:(id)sender
{
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
    myMarker = marker;
    alreadyTappedMarker = marker;
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
    self.navigationController.navigationBar.topItem.title =  storage.categoryNamesArray[0];
    _detailSubviewObject.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    
    _detailSubviewObject.translucentAlpha = 0.9;
    _detailSubviewObject.translucentStyle = UIBarStyleBlack;
    _detailSubviewObject.translucentTintColor = [UIColor clearColor];
    
    _bigDetailPanel.translucentAlpha = 0.9;
    _bigDetailPanel.translucentStyle = UIBarStyleBlack;
    _bigDetailPanel.translucentTintColor = [UIColor clearColor];
}

-(void)displayInitialObjectsMarkers
{
    Spot *spot;
    for (PFObject* object in dataModel.filteredObjects) {
        position = CLLocationCoordinate2DMake([object [@"latitude"] floatValue], [object [@"longitude"] floatValue]);
        spot = [[Spot alloc] initWithPosition:position];
        [clusterManager addItem:spot];
        [clusterManager cluster];
    }
}

-(void)fillSubview :(NSNotification*) notification
{
 [_detailSubviewObject setDetail:dataModel.infoForMarker.name :position.longitude :position.latitude];
    [_bigDetailPanel setDataOfWindow:dataModel.infoForMarker];
}


////setting observance over the main currency (KVO)


-(void)dealloc
{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

//#import "MapViewController.h"
//#import "DirectionAndDistance.h"
//#import "SWRevealViewController.h"
//#import "GClusterManager.h"
//#import "NonHierarchicalDistanceBasedAlgorithm.h"
//#import "GDefaultClusterRenderer.h"
//#import "BigDetailPanel.h"
//
//
//GMSMarker *myMarker;
//NSString *iconOfSelectedMarker;
//GClusterManager *clusterManager;
//
//
//@interface MapViewController () {
//    
//    CLLocationCoordinate2D position;    //   for temporary markers}
//    GMSMarker *alreadyTappedMarker;
//    DirectionAndDistance *findTheDirection;         SINGLETONE
//     GMSCameraPosition *previousCameraPosition_;
//    SlideMenuViewController *menuObject;
//    PlaceCategory *storage;
// //   RequestsClass *requestToDisplay;
//    MapSingletone *mapSingletone;              NON SINGELTONE
//    int trackTapps;
//    DataModel *dataModel;
//    NSString *category;
//   }
//
//@end
//
//static NSString *kMDDirectionsURL = @"http://maps.googleapis.com/maps/api/directions/json?";
//
//@implementation MapViewController
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    storage = [PlaceCategory sharedManager];
//    mapSingletone = [MapSingletone sharedManager];
//    iconOfSelectedMarker = @"parking.png";
//    dataModel = [DataModel sharedModel];
//    [dataModel firstLoad];
//    
//    findTheDirection = [DirectionAndDistance new];
//    menuObject = [[SlideMenuViewController alloc] init];
//    [self firstMapLaunch];
//    
//    clusterManager = [GClusterManager managerWithMapView:mapSingletone.mapView_
//                                               algorithm:[[NonHierarchicalDistanceBasedAlgorithm alloc] init]
//                                                renderer:[[GDefaultClusterRenderer alloc] initWithMapView:mapSingletone.mapView_]];
//   
//    [self displayInitialObjectsMarkers];
//    trackTapps = 0;
//    [self setAppearance];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSelectedCategory:) name:@"setSelectedCategory" object:nil];
//    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayObjectsMarkers:) name:@"displayNewPlaces" object:nil];
//   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performFilterRenew :) name:@"performFilterRenew" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(renewMyMap:) name:@"performMapRenew" object:nil];
//
//   // [[NSNotificationCenter defaultCenter] addObserver:_bigDetailPanel selector:@selector(setDataOfWindow:) name:@"renewDataOfSubview" object:nil];
//    //hide detailInfo views
//    [_bigDetailPanel register];
//    [_detailSubviewObject setHidden:YES];
//    [_bigDetailPanel setHidden:YES];
//}
//
//-(void)renewMyMap :(NSNotification*)notification
//{
//    [clusterManager removeItems];
//    [dataModel performFilterRenew :category];
//    [self displayInitialObjectsMarkers];
//}
//
//- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)cameraPosition
//{
//    assert(mapView == _mapView);
//    // Don't re-compute clusters if the map has just been panned/tilted/rotated.
//    GMSCameraPosition *currentPosition = [mapView camera];
//    if (previousCameraPosition_ != nil && previousCameraPosition_.zoom == currentPosition.zoom) {
//        return;
//    }
//    previousCameraPosition_ = [mapView camera];
//    [clusterManager cluster];
//}
//
//-(void)setSelectedCategory : (NSNotification *)notification
//{
//    [menuObject setIndexValueWithCompletion:^(NSInteger indexValue){
//        self.navigationController.navigationBar.topItem.title = storage.categoryNamesArray[indexValue];
//        category = storage.categoryNamesArray[indexValue];
//
//    }];
//}
//
//-(void)viewWillAppear:(BOOL)animated
//{
//    mapSingletone.polyline.map = mapSingletone.mapView_;
//    [self.tabBarController.tabBar setHidden:NO];
//    [self.navigationController.navigationBar setHidden:NO];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    [_detailSubviewObject setHidden:YES];
//    [_bigDetailPanel setHidden:YES];
//
//}
//
//-(BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
//{
//    if ([marker isEqual:alreadyTappedMarker]&&(trackTapps>0)) {
//        mapSingletone.polyline.map = nil;
//        mapSingletone.polyline = nil;
//        trackTapps --;
//        return YES;
//    } else if ([marker isEqual:alreadyTappedMarker]) {
//        mapSingletone.polyline = nil;
//        return YES;
//    } else {
//        trackTapps ++;
//        mapSingletone.polyline.map = nil;
//        //position = CLLocationCoordinate2DMake(marker.position.longitude,marker.position.latitude);
//        _markerPosition = CLLocationCoordinate2DMake(marker.position.longitude,marker.position.latitude);
//        //[storage.detailInfoForObject setDetailInfoForTappedMarker:position];
//        self.detailSubviewObject.distanceLabel.text= @"";
//       // [self.detailSubviewObject setDetail:storage.detailInfoForObject.name :marker.position.longitude :marker.position.latitude];
//        [_detailSubviewObject setHidden:NO];
//        return YES;
//    }
//}
//- (IBAction)pressButtonMenu:(id)sender
//{
//    [self.revealViewController revealToggle:sender];
//    [_bigDetailPanel setHidden:YES];
//    [_detailSubviewObject setHidden:YES];
//}
//- (IBAction)pressSmallInfoButton:(id)sender
//{
//   // [_bigDetailPanel setDataOfWindow];
//    [_detailSubviewObject setHidden:YES];
//    [_bigDetailPanel setHidden:NO];
//}
//
//-(void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
//{
//    [_detailSubviewObject setHidden:YES];
//    [_bigDetailPanel setHidden:YES];
//}
//
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    CLLocation *currentLocation = [locations lastObject];
//    [mapSingletone.mapView_ animateToLocation:currentLocation.coordinate];
//    [_locationManager stopUpdatingLocation];
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//}
//
//-(void)firstMapLaunch
//{
//    self.locationManager = [[CLLocationManager alloc] init];
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    self.locationManager.delegate = self;
//    [_locationManager startUpdatingLocation];
//    position = CLLocationCoordinate2DMake(49.8327176,23.9970189);
//    GMSCameraPosition *camera=[GMSCameraPosition cameraWithTarget:position zoom:13];
//    mapSingletone.mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
//    _mapView.delegate = self;
//    mapSingletone.mapView_ = self.mapView;
//    [mapSingletone.mapView_ animateToLocation:position];
//    [mapSingletone.mapView_ animateToZoom:13];
//    mapSingletone.mapView_.myLocationEnabled= YES;
//      mapSingletone.mapView_.settings.myLocationButton = YES;
//    GMSMarker *marker = [GMSMarker markerWithPosition:position];  //my location
//    alreadyTappedMarker = marker;
//    myMarker = marker;
//    marker.icon = [UIImage imageNamed:@"home.png"];
//    marker.map = mapSingletone.mapView_;
//    [mapSingletone.waypoints_ addObject:marker];
//    mapSingletone.positionString = [[NSString alloc] initWithFormat:@"%f,%f",
//                                    marker.position.latitude,marker.position.longitude];
//    [mapSingletone.waypointStrings_ addObject:mapSingletone.positionString];
//}
//
//
//-(void)setAppearance
//{
//    self.tabBarController.tabBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
//    self.tabBarController.tabBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
//    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
//    self.navigationController.navigationBar.topItem.title =  storage.categoryNamesArray[0];
//    _detailSubviewObject.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
//    //set up smallview
//    _detailSubviewObject.translucentAlpha = 0.9;
//    _detailSubviewObject.translucentStyle = UIBarStyleBlack;
//    _detailSubviewObject.translucentTintColor = [UIColor clearColor];
//    //set up bigview
//    _bigDetailPanel.translucentAlpha = 0.9;
//    _bigDetailPanel.translucentStyle = UIBarStyleBlack;
//    _bigDetailPanel.translucentTintColor = [UIColor clearColor];
//}
//
//
//-(void)displayObjectsMarkers : (NSNotification *)notification     ////////////////////////////
//{
////    
////    [self displayInitialObjectsMarkers];
//}
//
//-(void)displayInitialObjectsMarkers      ////////////////////////////
//{
//    Spot *spot;
//    for (PFObject* object in dataModel.filteredObjects) {
//        position = CLLocationCoordinate2DMake([object [@"latitude"] floatValue], [object [@"longitude"] floatValue]);
//        spot = [[Spot alloc] initWithPosition:position];
//        [clusterManager addItem:spot];
//        [clusterManager cluster];
//    }
//}
//
////-(void)cleanMarkersFromMap:(NSString*)category
////{
////    [clusterManager removeItems];
////    [dataModel.filteredObjects removeAllObjects];
////}
////
////
////-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
////                       change:(NSDictionary *)change context:(void *)context {
////    if ([keyPath isEqualToString:@"selectedCategoryOfDisplayedObjects"]) {
////        [_filteredObjects removeAllObjects];
////        for (PFObject* objectFromDataBase in _foundObjects) {
////            if ([objectFromDataBase[@"type"]isEqualToString:[object selectedCategoryOfDisplayedObjects]])
////                
////                [_filteredObjects addObject:objectFromDataBase];
////        }
////    }
////}
//
//
////setting observance over the main currency (KVO)
//-(void)setObservingForSelectedCategory {
//    [menuObject addObserver:self forKeyPath:@"selectedCategoryOfDisplayedObjects"
//                    options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
//    
//}
//
//
//-(void)dealloc {
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//
//@end
