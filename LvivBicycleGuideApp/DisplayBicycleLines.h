//
//  DisplayBicycleLines.h
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 11/10/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DirectionAndDistance.h"
#import "RoutePoints.h"
#import <Parse/Parse.h>

@interface DisplayBicycleLines : NSObject

@property (nonatomic, strong)NSArray *arrayOfPathes;
@property (nonatomic, strong)NSMutableArray *arrayOfStartLocations;
@property (nonatomic, strong)NSMutableArray *arrayOfEndLocations;
@property (nonatomic, strong)NSArray *arrayOfPoints;
@property (nonatomic, strong)GMSPath *path;

-(id) init;
-(void)loadLines;

@end
