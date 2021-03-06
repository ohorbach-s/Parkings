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
#import <Parse/Parse.h>
#import "TableViewController.h"
#import "SlideMenuControllerViewController.h"
#import "CMPopTipView.h"

@class BigInfoSubview;
@class SmallInfoSubview;

@interface MapViewController : UIViewController<GMSMapViewDelegate, CLLocationManagerDelegate, TableRouteDelegate, CMPopTipViewDelegate>
@property (nonatomic)BOOL customRouteMode;
@property (weak, nonatomic) IBOutlet UISwitch *switchObject;


@end
