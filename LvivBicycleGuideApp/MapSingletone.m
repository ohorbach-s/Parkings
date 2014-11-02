//
//  MapSingletone.m
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 10/29/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "MapSingletone.h"

@implementation MapSingletone

+ (id)sharedManager {
    static MapSingletone *sharedSingletoneManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingletoneManager = [[MapSingletone alloc] init];
    });
    
    return sharedSingletoneManager;
}
- (id)init {
    
    if (self = [super init]) {
        _waypoints_ = [[NSMutableArray alloc]init];
        _waypointStrings_ = [[NSMutableArray alloc]init];
    }
    return self;
}



@end
