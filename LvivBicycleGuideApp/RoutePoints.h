//
//  MapSingletone.h
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 10/29/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoutePoints : NSObject

@property (nonatomic,strong) NSMutableArray *waypoints_;
@property (nonatomic,strong) NSMutableArray *waypointStrings_;
@property (nonatomic,strong) NSArray *_waypoints;
@property (nonatomic,strong) NSString *positionString;

+ (id)sharedManager;

@end
