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
#import "DetailInfoClass.h"
#import "RequestsClass.h"
#import <Parse/Parse.h>
#import "DetailInfoClass.h"
#import "SmallDetaiPanel.h"
#import "BigDetailPanel.h"
#import "SlideMenuViewController.h"
#import "StorageClass.h"
#import "MapSingletone.h"

@interface MapViewController : UIViewController<GMSMapViewDelegate, CLLocationManagerDelegate>
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UINavigationItem *menuButton;
@property (unsafe_unretained, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) IBOutlet SmallDetaiPanel *detailSubviewObject;
@property (strong, nonatomic) IBOutlet BigDetailPanel *bigDetailPanel;











@end
