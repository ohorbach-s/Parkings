//
//  Category.h
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 10/28/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaceDetailInfo.h"

@interface PlaceCategories : NSObject

@property(nonatomic, strong)NSArray *markersImages;
@property(nonatomic, strong)NSArray *categoryNamesArray;

+ (id)sharedManager;

@end

