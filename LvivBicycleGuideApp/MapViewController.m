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
    CLLocationCoordinate2D position;
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
}
@property (weak, nonatomic) IBOutlet BigInfoSubview *bigInfoSubview;
@property (weak, nonatomic) IBOutlet UIButton *routeButton;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UINavigationItem *menuButton;
@property (unsafe_unretained, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet SmallInfoSubview *smallInfoSubview;

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
    clusterManager = [GClusterManager managerWithMapView:self.mapView algorithm:[[NonHierarchicalDistanceBasedAlgorithm alloc] init]
                                                renderer:[[GDefaultClusterRenderer alloc] initWithMapView:self.mapView]];
    [self displayCategoryMarkers];
    [self setAppearance];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSelectedCategory:) name:@"setSelectedCategory" object:nil];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(renewMyMap:) name:@"performMapAndTableRenew" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fillSubview:) name:@"fillSubviewOfMap" object:nil];
    [_smallInfoSubview setHidden:YES];
    [_bigInfoSubview setHidden:YES];
    TableViewController *controller = [[[self.tabBarController.viewControllers objectAtIndex:1] childViewControllers ]objectAtIndex:0];
    controller.delagate =self;
}

-(void)setObservingForMarkerIcon {
    //SlideMenuViewController *menuController = [[self.revealViewController childViewControllers] objectAtIndex:0];
    
//    [menuController addObserver:controller
//                     forKeyPath:@"markerIcon"
//                        options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
//    [menuController addObserver:controller
//                     forKeyPath:@"category"
//                        options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
//    [menuController addObserver:self
//                     forKeyPath:@"category"
//                        options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil ];
    
   TableViewController *controller = [[[self.tabBarController.viewControllers objectAtIndex:1] childViewControllers ]objectAtIndex:0]; 
    
    [dataModel.currentCategory addObserver:self
                forKeyPath:@"categoryName"
                                   options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [dataModel.currentCategory addObserver:self
                                forKeyPath:@"categoryIcon"
                                   options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [dataModel.currentCategory addObserver:controller
                forKeyPath:@"categoryIcon"
                   options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                       change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"categoryName"]) {
        self.navigationController.navigationBar.topItem.title = [object categoryName];
        //category = [object categoryName];
        
        //[clusterManager removeItems];
       // [self displayCategoryMarkers];
    }
    
    if ([keyPath isEqualToString:@"categoryIcon"]) {
        //category = [object categoryName];
        
        [clusterManager removeItems];
        [self displayCategoryMarkers];
    }

}

-(void)cleanPolylineFromMap
{
    polyline.map = nil;
    polyline = nil;
}

//-(void)renewMyMap :(NSNotification*)notification
//{
////    [menuObject setIndexValueWithCompletion:^(NSInteger indexValue){
////        self.navigationController.navigationBar.topItem.title = placeCategory.categoryNamesArray[indexValue];
////        category = placeCategory.categoryNamesArray[indexValue];
//       
//        //[dataModel reactToCategorySelection :category];
//    
//   // }];
//    
//
//    
//    
//    
//    [clusterManager removeItems];   
//    [self displayCategoryMarkers];
//
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
//    [menuObject setIndexValueWithCompletion:^(NSInteger indexValue){
//       self.navigationController.navigationBar.topItem.title = placeCategory.categoryNamesArray[indexValue];
//        category = placeCategory.categoryNamesArray[indexValue];
//    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [_smallInfoSubview setHidden:YES];
    [_bigInfoSubview setHidden:YES];
}

-(BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    if ([marker isEqual:alreadyTappedMarker]) {
        return YES;
    } else if([marker isEqual:userPositionMarker]) {
        
        polyline.map = nil;
        polyline = nil;
        return YES;
    } else {
        alreadyTappedMarker = marker;
        position = marker.position;
        self.smallInfoSubview.distanceLabel.text= @"";
        [_smallInfoSubview setHidden:NO];
        [dataModel buildInfoForMarker:marker];
        return YES;
    }
}

- (void)createScreenshotAndLayoutWithScreenshotCompletion:(dispatch_block_t)screenshotCompletion
{
    self.bigInfoSubview.alpha = 0.f;
    self.bigInfoSubview.alpha = 1.f;
    if (screenshotCompletion != nil) {
        screenshotCompletion();
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0L), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            CATransition *transition = [CATransition animation];
            transition.duration = 0.2;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionFade;
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        });
    });
    
}

- (IBAction)pressButtonMenu:(id)sender
{
    [self.revealViewController revealToggle:sender];
    [_bigInfoSubview setHidden:YES];
    [_smallInfoSubview setHidden:YES];
}

-(void)findDirection:(float)markerLatitude :(float)markerLongitude
{
    [findTheDirection buildTheRouteAndSetTheDistance:markerLongitude
                                                    :markerLatitude
                                                    : ^(NSString* theDistance,
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
    [self findDirection:[dataModel.infoForMarker.latitude floatValue]:[dataModel.infoForMarker.longtitude floatValue]];
}

//+ (void)transitionFromView:(UIView *)fromView
//                    toView:(UIView *)toView
//                  duration:(NSTimeInterval)duration
//                   options:(UIViewAnimationOptions)options
//                completion:(void (^)(BOOL finished))completion
//{
//
//}

- (IBAction)pressSmallInfoButton:(id)sender
{
//    [self createScreenshotAndLayoutWithScreenshotCompletion:^{
//        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//        opacityAnimation.fromValue = @0.;
//        opacityAnimation.toValue = @1.;
//        opacityAnimation.duration = 0.2f * 0.5f;
//        
//        CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//        
//        CATransform3D startingScale = CATransform3DScale(self.bigInfoSubview.layer.transform, 0, 0, 0);
//        CATransform3D overshootScale = CATransform3DScale(self.bigInfoSubview.layer.transform, 1.05, 1.05, 1.0);
//        CATransform3D undershootScale = CATransform3DScale(self.bigInfoSubview.layer.transform, 0.98, 0.98, 1.0);
//        CATransform3D endingScale = self.bigInfoSubview.layer.transform;
//        
//        NSMutableArray *scaleValues = [NSMutableArray arrayWithObject:[NSValue valueWithCATransform3D:startingScale]];
//        NSMutableArray *keyTimes = [NSMutableArray arrayWithObject:@0.0f];
//        NSMutableArray *timingFunctions = [NSMutableArray arrayWithObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
//        
//        
//        [scaleValues addObjectsFromArray:@[[NSValue valueWithCATransform3D:overshootScale], [NSValue valueWithCATransform3D:undershootScale]]];
//        [keyTimes addObjectsFromArray:@[@0.5f, @0.85f]];
//        [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//        
//        
//        [scaleValues addObject:[NSValue valueWithCATransform3D:endingScale]];
//        [keyTimes addObject:@1.0f];
//        [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//        
//        scaleAnimation.values = scaleValues;
//        scaleAnimation.keyTimes = keyTimes;
//        scaleAnimation.timingFunctions = timingFunctions;
//        
//        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
//        animationGroup.animations = @[scaleAnimation, opacityAnimation];
//        animationGroup.duration = 0.5f;
//        
//        [self.bigInfoSubview.layer addAnimation:animationGroup forKey:nil];
//        
//    }];
    
//    [SmallInfoSubview transitionFromView:_smallInfoSubview toView:_bigInfoSubview duration:0.7 options:UIViewAnimationOptionTransitionFlipFromTop| UIViewAnimationOptionShowHideTransitionViews  ///completion:nil];
  //   [UIView commitAnimations];
  //  [SmallInfoSubview animateWithDuration:0.7 animations:^{
        
  //  } completion:^(BOOL finished) {
//        _smallInfoSubview.hidden = YES;
//        _bigInfoSubview.hidden = NO;

   // }];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
 //   [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationCurveEaseInOut
  //                   animations:^{
  //                       _smallInfoSubview.transform =   CGAffineTransformScale(_smallInfoSubview.transform, 50.0, 20.0);
   //                      _smallInfoSubview.alpha = 0.3f;
  //                   }
    //                 completion:nil];
    _smallInfoSubview.alpha = 0.8;
    [_smallInfoSubview setHidden:YES];
    [_bigInfoSubview setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"blue1-1.png"]]];
    [_bigInfoSubview setHidden:NO];
    
    [UIView animateWithDuration:0.2 animations:
     
     ^(void){
         
         [_bigInfoSubview.layer setCornerRadius:30.0f];
         
         // border
         [_bigInfoSubview.layer setBorderColor:[UIColor lightGrayColor].CGColor];
         [_bigInfoSubview.layer setBorderWidth:1.5f];
         
         // drop shadow
         [_bigInfoSubview.layer setShadowColor:[UIColor grayColor].CGColor];
         [_bigInfoSubview.layer setShadowOpacity:0.7];
         [_bigInfoSubview.layer setShadowRadius:3.0];
         [_bigInfoSubview.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
         
         _bigInfoSubview.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.1f, 1.1f);
         
       //  _bigInfoSubview.alpha = 0.5;
         
     }
     
                    completion:^(BOOL finished){
                        
                        [self bounceOutAnimationStoped];
                    }];

    
    //[_smallInfoSubview setHidden:YES];
    //[_bigInfoSubview setHidden:NO];
}




- (void)bounceOutAnimationStoped

{
    
    [UIView animateWithDuration:0.1 animations:
     
     ^(void){
         
         _bigInfoSubview.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.9, 0.9);
         
         _bigInfoSubview.alpha = 0.8;
         
     }
     
                    completion:^(BOOL finished){
                        
                        [self bounceInAnimationStoped];
                        
                    }];
    
}

- (void)bounceInAnimationStoped

{
    
    [UIView animateWithDuration:0.1 animations:
     
     ^(void){
         
         _bigInfoSubview.transform = CGAffineTransformScale(CGAffineTransformIdentity,1, 1);
         
         _bigInfoSubview.alpha = 1.0;
         
     }
     
                    completion:^(BOOL finished){
                        
                        [self animationStoped];
                        
                    }];
    
}

- (void)animationStoped

{
    
}



-(void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [_smallInfoSubview setHidden:YES];
    [_bigInfoSubview setHidden:YES];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    [self.mapView animateToLocation:currentLocation.coordinate];
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
    [_mapView animateToCameraPosition:camera];
    [_mapView animateToZoom:13];
    _mapView.delegate = self;
    _mapView.myLocationEnabled= YES;
    _mapView.settings.myLocationButton = YES;
    GMSMarker *marker = [GMSMarker markerWithPosition:position];  //my location
    userPositionMarker = marker;
    alreadyTappedMarker = marker;
    marker.icon = [UIImage imageNamed:@"home.png"];
    marker.map = _mapView;
    [routePoints.waypoints_ addObject:marker];
    routePoints.positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                    marker.position.latitude,marker.position.longitude];
    [routePoints.waypointStrings_ addObject:routePoints.positionString];
}

-(void)setAppearance
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.tabBarController.tabBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    self.tabBarController.tabBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.navigationController.navigationBar.topItem.title =  placeCategories.categoryNamesArray[0];
    _smallInfoSubview.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    _smallInfoSubview.translucentAlpha = 0.9;
    _smallInfoSubview.translucentStyle = UIBarStyleBlack;
    _smallInfoSubview.translucentTintColor = [UIColor clearColor];
    
    
    
   // _bigInfoSubview.translucentAlpha = 0.9;
   // _bigInfoSubview.translucentStyle = UIBarStyleBlack;
   // _bigInfoSubview.translucentTintColor = [UIColor clearColor];
}


-(void)displayCategoryMarkers
{
    Spot *spot;
    for (PFObject* object in dataModel.selectedPlaces) {
        position = CLLocationCoordinate2DMake([object [@"latitude"] floatValue], [object [@"longitude"] floatValue]);
        spot = [[Spot alloc] initWithPosition:position];
        [clusterManager addItem:spot];
        [clusterManager cluster];
    }
}

-(void)fillSubview :(NSNotification*) notification
{
    [_smallInfoSubview setDetail:dataModel.infoForMarker.name :position.longitude :position.latitude];
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
