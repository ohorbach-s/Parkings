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
#import "DisplayBicycleLines.h"

@interface MapViewController ()
{
    CLLocationCoordinate2D _position;
    GMSMarker *alreadyTappedMarker;
    PlaceCategories *placeCategories;
    DataModel *dataModel;
    DirectionAndDistance *findTheDirection;
    RoutePoints *routePoints;
    GMSCameraPosition *previousCameraPosition_;
    GMSPolyline *polyline;
    GMSPolyline *customPolyline;
    GMSPolyline *bicyclePolyline;
    GMSMarker *userPositionMarker;
    CLLocation *currentLocation;
    GMSMarker *startPoint;
    GMSMarker *endPoint;
    NSMutableDictionary *markersToPutOnMap;
    DisplayBicycleLines *displayBicycleLines;
}

@property (weak, nonatomic) IBOutlet BigInfoSubview *bigInfoSubview;
@property (weak, nonatomic) IBOutlet UIButton *routeButton;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UINavigationItem *menuButton;
@property (unsafe_unretained, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet SmallInfoSubview *smallInfoSubview;
@property (weak, nonatomic) IBOutlet UIButton *complaintButton;

@end

static NSString *kMDDirectionsURL = @"http://maps.googleapis.com/maps/api/directions/json?";

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    displayBicycleLines = [[DisplayBicycleLines alloc] init];
    placeCategories = [PlaceCategories sharedManager];
    routePoints = [RoutePoints sharedManager];
    markersToPutOnMap = [[NSMutableDictionary alloc] init];
    dataModel = [DataModel sharedModel];
    findTheDirection = [DirectionAndDistance sharedManager];
    [self firstMapLaunch];
    [self setAppearance];
    [self displayLines];
    [_locationManager startUpdatingLocation];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fillSubview:)
                                                 name:@"fillSubviewOfMap" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayCategoryMarkers:)
                                                 name:@"showMarker" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cleanDeselectedCategory:)
                                                 name:@"cleanMarkers" object:nil];
    TableViewController *controller = [[[self.tabBarController.viewControllers objectAtIndex:1]
                                        childViewControllers ]objectAtIndex:0];
    controller.delagate =self;
    
    [[NSNotificationCenter defaultCenter] addObserver:controller selector:@selector(reloadTableView:) name:@"performMapAndTableRenew" object:nil];
    [dataModel changeCategory:0];
    [_smallInfoSubview setHidden:YES];
    [_bigInfoSubview setHidden:YES];
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
//disclose clustered markers
- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)cameraPosition
{
    assert(mapView == _mapView);
    // Don't re-compute clusters if the map has just been panned/tilted/rotated.
    GMSCameraPosition *currentPosition = [mapView camera];
    NSLog(@"camera zoom   %f %@",self.mapView.camera.zoom, self.mapView.selectedMarker);
    if (previousCameraPosition_ != nil && previousCameraPosition_.zoom == currentPosition.zoom) {
        return;
    } else if([markersToPutOnMap count])[self displayMarkers];
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
    } else if (([marker isEqual:startPoint])||([marker isEqual:endPoint]) ) {
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
    if (currentLocation){
    [findTheDirection buildTheRouteAndSetTheDistanceForLongitude:markerLongitude
                                                     AndLatitude:markerLatitude
                                           WithCompletionHandler: ^(NSString* theDistance,
                                                                    GMSPolyline *polylineFromBlock) {
                                               self.smallInfoSubview.distanceLabel.text = theDistance;
                                               polyline.map = nil;
                                               polyline = nil;
                                               polyline = polylineFromBlock;
                                               polyline.strokeColor = [UIColor colorWithRed:0/255.0f green:133/255.0f blue:0/255.0f alpha:1.0f];
                                               polyline.strokeWidth = 3.0f;
                                               polyline.map = _mapView;
                                               [routePoints.waypoints_ removeObject:[routePoints.waypoints_ lastObject]];
                                               [routePoints.waypointStrings_ removeObject:[routePoints.waypointStrings_ lastObject]];
                                               CLLocationCoordinate2D boundLocation = CLLocationCoordinate2DMake(markerLatitude,markerLongitude);
                                               GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
                                               bounds = [bounds includingCoordinate:userPositionMarker.position];
                                               bounds = [bounds includingCoordinate:boundLocation];
                                               [_mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:30.0f]];
                                           }];
    } else {
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to build the route"message:@"Location service is turned off" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
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

//stop animated appearance
- (void)bounceInAnimationStoped
{
    [UIView animateWithDuration:0.1 animations:^(void){
        _bigInfoSubview.transform = CGAffineTransformScale(CGAffineTransformIdentity,1, 1);
    }
                     completion:^(BOOL finished){
                     }];
}
-(void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
    [_bigInfoSubview setHidden:YES];
}
//hide each of shown subview
-(void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSString *positionString;
    [_smallInfoSubview setHidden:YES];
    [_bigInfoSubview setHidden:YES];
    NSLog(@"%f %f %f", coordinate.latitude, coordinate.longitude, self.mapView.camera.zoom);
    
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
                    customPolyline.strokeColor =[UIColor colorWithRed:255/255.0f green:161/255.0f blue:4/255.0f alpha:1.0f];
                    customPolyline.strokeWidth = 2.0f;
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
    for (NSString *temp in tags) {
        [dataModel.arrangedDistances removeObjectForKey:temp];
        for (PFObject *object in [dataModel.arrangedPlaces valueForKey:temp]) {
            CLLocation *second=[[CLLocation alloc]initWithLatitude:[object[@"latitude"]floatValue] longitude:[object[@"longitude"]floatValue]];
            CLLocationDistance distance = [currentLocation distanceFromLocation:second];
            [distancesToPassToDictionary addObject:[NSString stringWithFormat:@"%.2f", distance/1000]];
        }
        [dataModel.arrangedDistances setValue:[distancesToPassToDictionary mutableCopy] forKey:temp];
        [distancesToPassToDictionary removeAllObjects];
    }
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    userPositionMarker = [GMSMarker markerWithPosition:position];
    userPositionMarker.map = self.mapView;
    [self.mapView animateToLocation:position];
    alreadyTappedMarker = userPositionMarker;
    [routePoints.waypoints_ addObject:userPositionMarker];
    NSString *updatedPosition = [[NSString alloc] initWithFormat:@"%f,%f",
                                 userPositionMarker.position.latitude,userPositionMarker.position.longitude];
    [routePoints.waypointStrings_ removeAllObjects];
    [routePoints.waypointStrings_ addObject:updatedPosition];
    [_locationManager stopUpdatingLocation];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"performMapAndTableRenew" object:nil];
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
    _position = CLLocationCoordinate2DMake(49.837120,24.026780 );
    [self.mapView animateToLocation:_position];
    [_mapView animateToZoom:13.384848];
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
    _smallInfoSubview.backgroundColor = [UIColor clearColor];
    _smallInfoSubview.translucentAlpha = 1.;
    _smallInfoSubview.translucentStyle = UIBarStyleBlackTranslucent;
    [_smallInfoSubview.layer setCornerRadius:15.0f];
    _smallInfoSubview.translucentTintColor = [UIColor clearColor];
    _bigInfoSubview.backgroundColor = [UIColor clearColor];
    _bigInfoSubview.translucentAlpha = 1.;
    _bigInfoSubview.translucentStyle = UIBarStyleBlackTranslucent;
    [_bigInfoSubview.layer setCornerRadius:15.0f];
    _bigInfoSubview.translucentTintColor = [UIColor clearColor];
    self.switchObject.thumbTintColor = [UIColor colorWithRed:0/255.0f green:133/255.0f blue:0/255.0f alpha:1.0f];
    self.switchObject.onTintColor = [UIColor colorWithRed:215/255.0f green:255/255.0f blue:5/255.0f alpha:0.9f];
    self.switchObject.tintColor = [UIColor colorWithRed:0/255.0f green:133/255.0f blue:0/255.0f alpha:1.0f];
    self.switchObject.on = NO;
    self.complaintButton.clipsToBounds = YES;
    [self.complaintButton.layer setCornerRadius:15.0f];
}

-(void)displaySizedImages :(NSArray*)necessaryArrayOfImages {
    [self.mapView clear];
    for (GMSMarker *marker in [markersToPutOnMap valueForKey:dataModel.buttonTag]) {
        marker.map = nil;
    }
    [self displayLines];
    if(polyline) {
        polyline.map = self.mapView;
    }
    if(customPolyline) {
        customPolyline.map = self.mapView;
    }
    if ((startPoint)&&(endPoint)) {
        startPoint.map = self.mapView;
        endPoint.map = self.mapView;
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
        [tempMarkers removeAllObjects];
    }
    for (NSString *tag in dataModel.onTags)
    {
        for(GMSMarker *marker in [markersToPutOnMap valueForKey:tag])
            
        {
            marker.icon = [UIImage imageNamed:[necessaryArrayOfImages objectAtIndex:[tag intValue]]];
            marker.map = self.mapView;
        }
    }
}

-(void)displayMarkers
{
    if (self.mapView.camera.zoom < 12){
        [self displaySizedImages :placeCategories.dotMediumImages];
        
    }else if ((self.mapView.camera.zoom < 13) && ((self.mapView.camera.zoom > 12)))
    {
        [self displaySizedImages :placeCategories.dotLargeImages];
    } else if ((self.mapView.camera.zoom < 14) && ((self.mapView.camera.zoom > 12.5))){
        [self displaySizedImages :placeCategories.markersSmallImages];
    } else {
        [self displaySizedImages :placeCategories.markersImages];
    }
}

//display selected markers
-(void)displayCategoryMarkers: (NSNotification*) notification
{
    [self displayMarkers];
}

-(void)cleanDeselectedCategory:(NSNotification*) notification
{
    for (GMSMarker *marker in [markersToPutOnMap valueForKey:dataModel.buttonTag]) {
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

-(void)displayLines
{
    displayBicycleLines = [[DisplayBicycleLines alloc] init];
    for (NSString *encodedPath in displayBicycleLines.arrayOfPathes )
    {
        GMSPath *mypath = [GMSPath pathFromEncodedPath:encodedPath];
        bicyclePolyline = [GMSPolyline polylineWithPath:mypath];
        bicyclePolyline.strokeColor = [UIColor colorWithRed:48/255.0f green:52/255.0f blue:255/255.0f alpha:1.0f];
        bicyclePolyline.strokeWidth = 4.5f;
        bicyclePolyline.map = self.mapView;
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
