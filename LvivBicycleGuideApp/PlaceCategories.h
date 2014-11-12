//
//  Category.h
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 10/28/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaceDetailInfo.h"
//all categories class
@interface PlaceCategories : NSObject

@property(nonatomic, strong)NSArray *markersImages;
@property(nonatomic, strong)NSArray *categoryNamesArray;
@property (nonatomic, strong)NSArray *dotSmallImages;
@property (nonatomic, strong)NSArray *dotMediumImages;
@property (nonatomic, strong)NSArray *dotLargeImages;
@property (nonatomic, strong)NSArray *markersSmallImages;

+ (id)sharedManager;

@end

