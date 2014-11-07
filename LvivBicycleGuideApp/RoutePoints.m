//
//  MapSingletone.m
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 10/29/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "RoutePoints.h"

@implementation RoutePoints

+ (id)sharedManager
{
    static RoutePoints *sharedSingletoneManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingletoneManager = [[RoutePoints alloc] init];
    });
    
    return sharedSingletoneManager;
}
- (id)init
{
    if (self = [super init]) {
        _waypoints_ = [[NSMutableArray alloc]init];
        _waypointStrings_ = [[NSMutableArray alloc]init];
        _customWayPoints = [[NSMutableArray alloc] init];
        _customWaypointStrings = [[NSMutableArray alloc]init];
    }
    return self;
}



@end
