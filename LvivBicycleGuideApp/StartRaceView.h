//
//  StartRaceView.h
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 11/15/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RaceViewController.h"
#import "RNGridMenu.h"

@interface StartRaceView : UIViewController <GMSMapViewDelegate, CLLocationManagerDelegate, PassMapDelegate,RNGridMenuDelegate>
-(void)passMapp: (NSArray*)polylines :(CLLocationCoordinate2D)boundLocation :(CLLocationCoordinate2D)position;
@end
