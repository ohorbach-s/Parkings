//
//  RaceViewController.h
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 11/13/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RaceDetail.h"
#import <CoreLocation/CoreLocation.h>
#import "RaceTableView.h"

@protocol PassMapDelegate <NSObject>

-(void)passMapp: (NSArray*)polylines :(CLLocationCoordinate2D)boundLocation :(CLLocationCoordinate2D)position;

@end

@interface RaceViewController : UIViewController <GMSMapViewDelegate, CLLocationManagerDelegate, RaceDetailDelegate>
@property(nonatomic, weak)id<PassMapDelegate>passMapDelegate;
@property (nonatomic,strong)RaceDetail *raceDeteailInView;
@property (nonatomic, strong)PFObject *raceObject;

-(void)passRaceDetail:(RaceDetail*)raceDetail :(NSDate*)dateOfevent;

@end
