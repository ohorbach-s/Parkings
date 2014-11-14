//
//  RaceTableView.h
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 11/13/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class RaceDetail;

@protocol RaceDetailDelegate <NSObject>

-(void)passRaceDetail:(RaceDetail*)raceDetail;

@end

@interface RaceTableView : UITableViewController

@property(nonatomic, weak)id<RaceDetailDelegate> raceDelegate;

@end
