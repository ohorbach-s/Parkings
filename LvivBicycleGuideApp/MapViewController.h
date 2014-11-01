//
//  MapViewController.h
//  LvivBicycleGuideApp
//
//  Created by Alexxx on 10/17/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "RNFrostedSidebar.h"
//#import "DetailInfoClass.h"
////#import "RequestsClass.h"
#import <Parse/Parse.h>
////#import "DetailInfoClass.h"
//#import "SmallDetaiPanel.h"
////#import "BigDetailPanel.h"
//#import "SlideMenuViewController.h"
//#import "PlaceCategory.h"
//#import "MapSingletone.h"
//#import "Spot.h"
//#import "GClusterManager.h"
//#import "DataModel.h"

@class BigDetailPanel;
@class SmallDetaiPanel;



@interface MapViewController : UIViewController<GMSMapViewDelegate, CLLocationManagerDelegate, RNFrostedSidebarDelegate>
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UINavigationItem *menuButton;
@property (unsafe_unretained, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet SmallDetaiPanel *detailSubviewObject;
@property (weak, nonatomic) IBOutlet BigDetailPanel *bigDetailPanel;
//@property (weak, nonatomic)GMSMarker *tappedMarker;











@end
