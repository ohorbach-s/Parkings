////


////  MapViewController.m
////  LvivBicycleGuideApp
////
////  Created by Alexxx on 10/17/14.
////  Copyright (c) 2014 SoftServe. All rights reserved.
////

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "SmallInfoSubview.h"
#import "SlideMenuViewController.h"
#import "PlaceCategories.h"
#import "RoutePoints.h"
#import "Spot.h"
#import "GClusterManager.h"
#import "DataModel.h"
#import "BigInfoSubview.h"
#import "DirectionAndDistance.h"
#import "SWRevealViewController.h"
#import "NonHierarchicalDistanceBasedAlgorithm.h"
#import "GDefaultClusterRenderer.h"
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>

@interface MapViewController ()
{
    CLLocationCoordinate2D _position;
    SlideMenuViewController *menuObject;
    GMSMarker *alreadyTappedMarker;
    PlaceCategories *placeCategories;
    DataModel *dataModel;
    DirectionAndDistance *findTheDirection;
    RoutePoints *routePoints;
    GMSCameraPosition *previousCameraPosition_;
    GClusterManager *clusterManager;
    NSString *category;
    GMSPolyline *polyline;
    GMSMarker *userPositionMarker;
    CLLocation *currentLocation;
}
@property (weak, nonatomic) IBOutlet BigInfoSubview *bigInfoSubview;
@property (weak, nonatomic) IBOutlet UIButton *routeButton;
@property (nonatomic,strong) CLLocationManager *locationManager; //cluster manager
@property (weak, nonatomic) IBOutlet UINavigationItem *menuButton;
@property (unsafe_unretained, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet SmallInfoSubview *smallInfoSubview;
@property (nonatomic,strong)GMSMarker *marker;

@end

static NSString *kMDDirectionsURL = @"http://maps.googleapis.com/maps/api/directions/json?";

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    placeCategories = [PlaceCategories sharedManager];
    routePoints = [RoutePoints sharedManager];
    NSString *iconOfSelectedMarker;
    SlideMenuViewController *menuController = [[self.revealViewController childViewControllers] objectAtIndex:0];
    menuController.cleanPolylineDelegate = self;
    menuObject = [[SlideMenuViewController alloc] init];
    iconOfSelectedMarker = @"Parking.png";
    dataModel = [DataModel sharedModel];
    findTheDirection = [DirectionAndDistance sharedManager];
    [self setObservingForMarkerIcon];
    [self firstMapLaunch];
    clusterManager = [GClusterManager managerWithMapView:self.mapView
                                               algorithm:[[NonHierarchicalDistanceBasedAlgorithm alloc] init]
                                                renderer:[[GDefaultClusterRenderer alloc]
                                                          initWithMapView:self.mapView]];
    [self displayCategoryMarkers];
    [self setAppearance];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fillSubview:)
                                                 name:@"fillSubviewOfMap" object:nil];
    [_smallInfoSubview setHidden:YES];
    [_bigInfoSubview setHidden:YES];
    TableViewController *controller = [[[self.tabBarController.viewControllers objectAtIndex:1]
                                        childViewControllers ]objectAtIndex:0];
    controller.delagate =self;
}
//set observing for values
-(void)setObservingForMarkerIcon {
    TableViewController *controller = [[[self.tabBarController.viewControllers objectAtIndex:1]
                                        childViewControllers ]objectAtIndex:0];
    
    [dataModel.currentCategory addObserver:self
                                forKeyPath:@"categoryName"
                                   options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                   context:nil];
    [dataModel.currentCategory addObserver:self
                                forKeyPath:@"categoryIcon"
                                   options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                   context:nil];
    [dataModel.currentCategory addObserver:controller
                                forKeyPath:@"categoryIcon"
                                   options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                   context:nil];
}
//react to change of observed values
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context {
    if ([keyPath isEqualToString:@"categoryName"]) {
        ////////////////////////////////////////////////////////////////////////////////
        if ([[object categoryName] isEqualToString:@"Parking"]) {
            self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"Parkings", nil);
        } else if ([[object categoryName] isEqualToString:@"BicycleShop"]) {
            self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"Services", nil);
        } else if ([[object categoryName] isEqualToString:@"Cafe"]) {
            self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"Cafes", nil);
        } else if ([[object categoryName] isEqualToString:@"Supermarket"]) {
            self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"Supermarkets", nil);
        }
        ////////////////////////////////////////////////////////////////////////////////
        
//        self.navigationController.navigationBar.topItem.title = [object categoryName];
    }
    
    if ([keyPath isEqualToString:@"categoryIcon"]) {
        [clusterManager removeItems];
        [self displayCategoryMarkers];
    }
}
//remove routes to previous destinations
-(void)cleanPolylineFromMap
{
    polyline.map = nil;
    polyline = nil;
}
//disclose clustered markers
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

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [_smallInfoSubview setHidden:YES];
    [_bigInfoSubview setHidden:YES];
}
//remove displayed polyline if tapped user position marker, get information of tapped object
-(BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    if ([marker isEqual:alreadyTappedMarker]) {
        [_smallInfoSubview setHidden:NO];
        [dataModel buildInfoForMarker:marker];
        return YES;
    } else if([marker isEqual:userPositionMarker]) {
        polyline.map = nil;
        polyline = nil;
        return YES;
    } else {
        alreadyTappedMarker = marker;
        _position = marker.position;
        self.smallInfoSubview.distanceLabel.text= @"";
        [_smallInfoSubview setHidden:NO];
        [dataModel buildInfoForMarker:marker];
        return YES;
    }
}

- (IBAction)pressButtonMenu:(id)sender
{
    [self.revealViewController revealToggle:sender];
    [_bigInfoSubview setHidden:YES];
    [_smallInfoSubview setHidden:YES];
}
//polyline is built
-(void)findDirectionForLatitude:(float)markerLatitude  AndLongitude:(float)markerLongitude
{
    [findTheDirection buildTheRouteAndSetTheDistanceForLongitude:markerLongitude
                                                    AndLatitude:markerLatitude
                                                    WithCompletionHandler: ^(NSString* theDistance,
                                                        GMSPolyline *polylineFromBlock) {
                                                        self.smallInfoSubview.distanceLabel.text = theDistance;
                                                        polyline.map = nil;
                                                        polyline = nil;
                                                        polyline = polylineFromBlock;
                                                        polyline.map = _mapView;
                                                        [routePoints.waypoints_ removeObject:[routePoints.waypoints_ lastObject]];
                                                        [routePoints.waypointStrings_ removeObject:[routePoints.waypointStrings_ lastObject]];
                                                        CLLocationCoordinate2D boundLocation = CLLocationCoordinate2DMake(markerLatitude,markerLongitude);
                                                        GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
                                                        bounds = [bounds includingCoordinate:userPositionMarker.position];
                                                        bounds = [bounds includingCoordinate:boundLocation];
                                                        [_mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:30.0f]];
                                                    }];
}

- (IBAction)pressRouteButton:(id)sender
{
    [self findDirectionForLatitude:[dataModel.infoForMarker.latitude floatValue]AndLongitude:[dataModel.infoForMarker.longtitude floatValue]];
}
//open subview with complete information
- (IBAction)pressSmallInfoButton:(id)sender
{
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [_smallInfoSubview setHidden:YES];
    [_bigInfoSubview setHidden:NO];
    [UIView animateWithDuration:0.2 animations:^(void){
         [_bigInfoSubview.layer setCornerRadius:30.0f];
         // border
         [_bigInfoSubview.layer setBorderColor:[UIColor lightGrayColor].CGColor];
         [_bigInfoSubview.layer setBorderWidth:1.5f];
         // drop shadow
         _bigInfoSubview.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.1f, 1.1f);
     }
                     completion:^(BOOL finished){
                         [self bounceOutAnimationStoped];
                     }];
    self.bigInfoSubview.description.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor]};
}
//animated appearance of information subview
- (void)bounceOutAnimationStoped
{
    [UIView animateWithDuration:0.1 animations: ^(void){
         _bigInfoSubview.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.9, 0.9);
     }
                     completion:^(BOOL finished){
                         [self bounceInAnimationStoped];
                     }];
}
-(void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
    [_bigInfoSubview setHidden:YES];
}

//stop animated appearance
- (void)bounceInAnimationStoped
{
    [UIView animateWithDuration:0.1 animations:^(void){
        _bigInfoSubview.transform = CGAffineTransformScale(CGAffineTransformIdentity,1, 1);
    }
                     completion:^(BOOL finished){
                     }];
}
//hide each of shown subview
-(void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [_smallInfoSubview setHidden:YES];
    [_bigInfoSubview setHidden:YES];
    //[self.mapView.settings setAllGesturesEnabled:YES];
}
//findind a user location
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [_locationManager startUpdatingLocation];
    currentLocation = [locations lastObject];
    [self.mapView animateToLocation:currentLocation.coordinate];
//
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    
    if (!_marker) {
        _marker = [GMSMarker markerWithPosition:position];
        _marker.icon = [UIImage imageNamed:@"home.png"];
        _marker.map = self.mapView;
    } else {
        self.marker.map = nil;
       // _marker = [[GMSMarker alloc] init];
        self.marker.position = position;
        [self.marker setPosition:position];
        self.marker.map = self.mapView;
       // self.marker.map = nil;
}
    userPositionMarker = _marker;
    alreadyTappedMarker = _marker;
    [routePoints.waypoints_ addObject:_marker];
    routePoints.positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                  _marker.position.latitude,_marker.position.longitude];
    [routePoints.waypointStrings_ addObject:routePoints.positionString];
    [_locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
//initial map settings
-(void)firstMapLaunch
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    _position = CLLocationCoordinate2DMake(49.8327176,23.9970189);
   // GMSCameraPosition *camera=[GMSCameraPosition cameraWithTarget:position zoom:13];
   // [_mapView animateToCameraPosition:camera];
    [_mapView animateToZoom:13];
    _mapView.delegate = self;
    _mapView.myLocationEnabled= YES;
    _mapView.settings.myLocationButton = YES;
   // GMSMarker *marker = [GMSMarker markerWithPosition:position];  //my location
//    userPositionMarker = marker;
//    alreadyTappedMarker = marker;
//    marker.icon = [UIImage imageNamed:@"home.png"];
    //marker.map = _mapView;
    //[routePoints.waypoints_ addObject:marker];
    //routePoints.positionString = [[NSString alloc] initWithFormat:@"%f,%f",
     //                             marker.position.latitude,marker.position.longitude];
   // [routePoints.waypointStrings_ addObject:routePoints.positionString];
}
//setting view visual characteristics
-(void)setAppearance
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.tabBarController.tabBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    self.tabBarController.tabBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.navigationController.navigationBar.topItem.title =  NSLocalizedString(@"Parkings", nil);
    _smallInfoSubview.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    _smallInfoSubview.translucentAlpha = 0.9;
    _smallInfoSubview.translucentStyle = UIBarStyleBlack;
    _smallInfoSubview.translucentTintColor = [UIColor clearColor];
    _bigInfoSubview.translucentAlpha = 0.9;
    _bigInfoSubview.translucentStyle = UIBarStyleBlack;
    _bigInfoSubview.translucentTintColor = [UIColor clearColor];
}
//display selected markers
-(void)displayCategoryMarkers
{
    Spot *spot;
    for (PFObject* object in dataModel.selectedPlaces) {
        _position = CLLocationCoordinate2DMake([object [@"latitude"] floatValue], [object [@"longitude"] floatValue]);
        spot = [[Spot alloc] initWithPosition:_position];
        [clusterManager addItem:spot];
        [clusterManager cluster];
    }
}
//passing data to both of detail subviews
-(void)fillSubview :(NSNotification*) notification
{
    [_smallInfoSubview setDetailWithName:dataModel.infoForMarker.name AndLongitude:_position.longitude AndLatitude:_position.latitude];
    [_bigInfoSubview setDataOfWindow:dataModel.infoForMarker];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    SlideMenuViewController *menuController = [[self.revealViewController childViewControllers] objectAtIndex:0];
    TableViewController *controller = [[[self.tabBarController.viewControllers objectAtIndex:1] childViewControllers ]objectAtIndex:0];
    [menuController removeObserver:controller forKeyPath:@"markerIcon"];
    [menuController removeObserver:controller forKeyPath:@"category"];
}

@end
