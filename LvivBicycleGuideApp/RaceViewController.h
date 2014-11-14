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

@interface RaceViewController : UIViewController <GMSMapViewDelegate, CLLocationManagerDelegate, RaceDetailDelegate>

@property (nonatomic,strong)RaceDetail *raceDeteailInView;
-(void)passRaceDetail:(RaceDetail*)raceDetail;

@end
