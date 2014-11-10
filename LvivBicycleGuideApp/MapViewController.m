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
#import "AdditionMenuViewController.h"
//#import "SlideMenuControllerViewController.h"


@interface MapViewController ()
{
    CLLocationCoordinate2D _position;
    SlideMenuControllerViewController *menuObject;
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
    GMSMarker *startPoint;
    GMSMarker *endPoint;
    GMSPolyline *customPolyline;
    NSMutableDictionary *markersToPutOnMap;
    
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
    markersToPutOnMap = [[NSMutableDictionary alloc] init];
    NSString *iconOfSelectedMarker;
    SlideMenuControllerViewController *menuController = [[self.revealViewController childViewControllers] objectAtIndex:0];
    menuController.cleanPolylineDelegate = self;
    //menuController.cleanMarkersDelegate = self;
    menuObject = [[SlideMenuControllerViewController alloc] init];
    iconOfSelectedMarker = @"Parking.png";
    dataModel = [DataModel sharedModel];
    findTheDirection = [DirectionAndDistance sharedManager];
    [self setObservingForMarkerIcon];
    [self firstMapLaunch];
    clusterManager = [GClusterManager managerWithMapView:self.mapView
                                               algorithm:[[NonHierarchicalDistanceBasedAlgorithm alloc] init]
                                                renderer:[[GDefaultClusterRenderer alloc]
                                                          initWithMapView:self.mapView]];
    [self setAppearance];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fillSubview:)
                                                 name:@"fillSubviewOfMap" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayCategoryMarkers:)
                                                 name:@"showMarker" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cleanDeselectedCategory:)
                                                 name:@"cleanMarkers" object:nil];
    
    [_smallInfoSubview setHidden:YES];
    [_bigInfoSubview setHidden:YES];
    TableViewController *controller = [[[self.tabBarController.viewControllers objectAtIndex:1]
                                        childViewControllers ]objectAtIndex:0];
    controller.delagate =self;
    
    [_locationManager startUpdatingLocation];
    [[NSNotificationCenter defaultCenter] addObserver:controller selector:@selector(reloadTableView:) name:@"performMapAndTableRenew" object:nil];
}


- (IBAction)switchAction:(UISwitch *)sender {
    if (!self.switchObject.on) {
        startPoint.map = nil;
        startPoint = nil;
        endPoint.map = nil;
        endPoint = nil;
        customPolyline.map = nil;
        customPolyline = nil;
        [routePoints.customWayPoints removeAllObjects];
        [routePoints.customWaypointStrings removeAllObjects];
    }
}


//set observing for values
-(void)setObservingForMarkerIcon {
    TableViewController *controller = [[[self.tabBarController.viewControllers objectAtIndex:1]
                                        childViewControllers ]objectAtIndex:0];
    
    [dataModel addObserver:self
                                forKeyPath:@"currentCategory"
                                   options: NSKeyValueChangeInsertion |  NSKeyValueChangeRemoval
                                   context:nil];
//    [dataModel addObserver:self
//                                forKeyPath:@"currentCategory"
//                                   options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
//                                   context:nil];
    [dataModel addObserver:controller
                                forKeyPath:@"currentCategory"
                                   options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                   context:nil];
    
   // [dataModel addObserver:self forKeyPath:@"currentCategory" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}
//react to change of observed values
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context {
    if ([keyPath isEqualToString:@"currentCategory"]) {
  
//        if ([[object categoryName] isEqualToString:@"Parking"]) {
//            self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"Parkings", nil);
//        } else if ([[object categoryName] isEqualToString:@"BicycleShop"]) {
//            self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"Services", nil);
//        } else if ([[object categoryName] isEqualToString:@"Cafe"]) {
//            self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"Cafes", nil);
//        } else if ([[object categoryName] isEqualToString:@"Supermarket"]) {
//            self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"Supermarkets", nil);
//        }
        //[self displayCategoryMarkers];
//        self.navigationController.navigationBar.topItem.title = [object categoryName];
    }
    
//    if ([keyPath isEqualToString:@"categoryIcon"]) {
//        //[clusterManager removeItems];
//        [self displayCategoryMarkers];
//    }
//    
//    if ([keyPath isEqualToString:@"deselectedIcon"]) {
//        //[clusterManager removeItems];
//        [self cleanDeselectedCategory:[object deselectedIcon]];
//    }
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
    } else if (marker.icon == nil ) {
        return YES;
    } else {
        alreadyTappedMarker = marker;
        _position = marker.position;
        self.smallInfoSubview.distanceLabel.text= @"";
        [_smallInfoSubview setHidden:NO];
        [dataModel buildInfoForMarker:marker];
        CLLocation *first=[[CLLocation alloc]initWithLatitude:userPositionMarker.position.latitude longitude:userPositionMarker.position.longitude ];
        CLLocation *second=[[CLLocation alloc]initWithLatitude:marker.position.latitude longitude:marker.position.longitude];
        CLLocationDistance distance = [first distanceFromLocation:second];
        NSLog(@"%f   the distance",distance);
        
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
                                                        polyline.strokeColor = [UIColor colorWithRed:0/255.0f green:134/255.0f blue:8/255.0f alpha:1.0f];
                                                        polyline.strokeWidth = 5.0f;
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
         [_bigInfoSubview.layer setBorderColor:[UIColor yellowColor].CGColor];
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
    NSString *positionString;
    [_smallInfoSubview setHidden:YES];
    [_bigInfoSubview setHidden:YES];
    if (self.switchObject.on) {
        static int countTapps = 0;
        if (!endPoint.map) {
            countTapps++;
            if (countTapps == 1) {
                startPoint = [GMSMarker markerWithPosition:coordinate];
                [routePoints.customWayPoints addObject:startPoint];
                positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                  coordinate.latitude, coordinate.longitude];
                [routePoints.customWaypointStrings addObject:positionString];
                startPoint.icon = [UIImage imageNamed:@"start.png"];
                startPoint.map = _mapView;
            } else if (countTapps == 2) {
                endPoint = [GMSMarker markerWithPosition:coordinate];
                [routePoints.customWayPoints addObject:startPoint];
                positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                  coordinate.latitude, coordinate.longitude];
                [routePoints.customWaypointStrings addObject:positionString];
                endPoint.icon = [UIImage imageNamed:@"finish.png"];
                endPoint.map = _mapView;
                countTapps = 0;
                [findTheDirection findCustomRouteWithCompletionHandler:^(NSString *distance, GMSPolyline *polylineFromBlock){
                    customPolyline = polylineFromBlock;
                    customPolyline.map = _mapView;
                    customPolyline.tappable = YES;
                }];
                
            }
            
        }
    }
}

 -(void)mapView:(GMSMapView *)mapView didTapOverlay:(GMSOverlay *)overlay
{
 if ([overlay isKindOfClass:[GMSPolyline class]])
 {
     overlay.map = nil;
     overlay = nil;
     startPoint.map = nil;
     endPoint.map = nil;
     [routePoints.customWayPoints removeAllObjects];
     [routePoints.customWaypointStrings removeAllObjects];
 }

}

//findind a user location
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    currentLocation = [locations lastObject];
    [self.mapView animateToLocation:currentLocation.coordinate];
    
    NSMutableArray *distancesToPassToDictionary = [[NSMutableArray alloc] init];
    NSArray *tags = [NSArray arrayWithObjects:@"0", @"1", @"2", @"3", nil];
    
    for (NSString *temp in tags){
        [dataModel.arrangedDistances removeObjectForKey:temp];
        for (PFObject *object in [dataModel.arrangedPlaces valueForKey:temp])
    {
    CLLocation *second=[[CLLocation alloc]initWithLatitude:[object[@"latitude"]floatValue] longitude:[object[@"longitude"]floatValue]];
    CLLocationDistance distance = [currentLocation distanceFromLocation:second];
        [distancesToPassToDictionary addObject:[NSString stringWithFormat:@"%.2f", distance/1000]];
        
    }
    [dataModel.arrangedDistances setValue:[distancesToPassToDictionary mutableCopy] forKey:temp];
 [distancesToPassToDictionary removeAllObjects];
    }
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    self.marker = [GMSMarker markerWithPosition:position];

    self.marker.map = self.mapView;
    [self.mapView animateToLocation:position];
    userPositionMarker = _marker;
    alreadyTappedMarker = _marker;
    [routePoints.waypoints_ addObject:_marker];
    NSString *updatedPosition = [[NSString alloc] initWithFormat:@"%f,%f",
                                  _marker.position.latitude,_marker.position.longitude];
    [routePoints.waypointStrings_ removeAllObjects];
    [routePoints.waypointStrings_ addObject:updatedPosition];
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
    [_mapView animateToZoom:13];
    _mapView.delegate = self;
    _mapView.myLocationEnabled= YES;
    _mapView.settings.myLocationButton = YES;

}
//setting view visual characteristics
-(void)setAppearance
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.tabBarController.tabBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    self.tabBarController.tabBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.navigationController.navigationBar.topItem.title =  NSLocalizedString(@"Parkings", nil);
    //_smallInfoSubview.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.85];
    _smallInfoSubview.translucentAlpha = 0.9;
    _smallInfoSubview.translucentStyle = UIBarStyleBlack;
    _smallInfoSubview.translucentTintColor = [UIColor whiteColor];//colorWithRed:0/255.0f green:240/255.0f blue:129/255.0f alpha:0.7f];
    //_bigInfoSubview.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.85];
    _bigInfoSubview.translucentAlpha = 0.7;
    _bigInfoSubview.translucentStyle = UIBarStyleBlack;
    _bigInfoSubview.translucentTintColor =[[UIColor grayColor]colorWithAlphaComponent:0.85];
    self.switchObject.thumbTintColor = [UIColor colorWithRed:0/255.0f green:133/255.0f blue:0/255.0f alpha:1.0f];
    self.switchObject.onTintColor = [UIColor colorWithRed:215/255.0f green:255/255.0f blue:5/255.0f alpha:0.9f];
    self.switchObject.tintColor = [UIColor colorWithRed:0/255.0f green:133/255.0f blue:0/255.0f alpha:1.0f];
    self.switchObject.on = NO;
}
//display selected markers
-(void)displayCategoryMarkers: (NSNotification*) notification
{
     //Spot *spot;
    [self.mapView clear];
    for (GMSMarker *marker in [markersToPutOnMap valueForKey:dataModel.buttonTag])
    {
        marker.map = nil;
    }
    [[markersToPutOnMap valueForKey:dataModel.buttonTag] removeAllObjects];
    [markersToPutOnMap setValue:nil forKey:dataModel.buttonTag];
    NSMutableArray *tempMarkers = [[NSMutableArray alloc] init];
    for (NSString *tag in dataModel.onTags) {
        [markersToPutOnMap setValue:[[NSMutableArray alloc] init] forKey:tag];
        for (PFObject* object in [dataModel.arrangedPlaces valueForKey:tag]) {
            _position = CLLocationCoordinate2DMake([object [@"latitude"] floatValue], [object [@"longitude"] floatValue]);
            GMSMarker *marker = [GMSMarker markerWithPosition:_position];
            [[markersToPutOnMap valueForKey:tag] addObject:marker];
        }
        //[markersToPutOnMap setValue:[tempMarkers mutableCopy] forKey:tag];
        [tempMarkers removeAllObjects];
    }
    
    for (NSString *tag in dataModel.onTags)
    {
    for(GMSMarker *marker in [markersToPutOnMap valueForKey:tag])
        
    {
        marker.icon = [UIImage imageNamed:[placeCategories.markersImages objectAtIndex:[tag intValue]]];
        marker.map = self.mapView;
    }
    }
}

-(void)cleanDeselectedCategory:(NSNotification*) notification
{

    for (GMSMarker *marker in [markersToPutOnMap valueForKey:dataModel.buttonTag])
    {
        marker.map = nil;
    }
    [[markersToPutOnMap valueForKey:dataModel.buttonTag] removeAllObjects];
    [markersToPutOnMap setValue:nil forKey:dataModel.buttonTag];
    [self.mapView clear];
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
    SlideMenuControllerViewController *menuController = [[self.revealViewController childViewControllers] objectAtIndex:0];
    TableViewController *controller = [[[self.tabBarController.viewControllers objectAtIndex:1] childViewControllers ]objectAtIndex:0];
    [menuController removeObserver:controller forKeyPath:@"markerIcon"];
    [menuController removeObserver:controller forKeyPath:@"category"];
}

@end
