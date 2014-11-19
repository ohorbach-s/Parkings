//
//  DetailInfoClass.h
//  MapsDirections
//
//  Created by Yuliia on 10/21/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "MapViewController.h"
#import "DataModel.h"

@interface PlaceDetailInfo : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *longtitude;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *workTime;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *homePage;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSMutableArray *complaints;

@end
