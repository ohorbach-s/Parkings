//
//  PlaceCategory.m
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 11/3/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "PlaceCategory.h"
#import "PlaceCategories.h"

@implementation PlaceCategory

- (id)init
{
    
    if (self = [super init]) {
        _categoryName = @"Parking";
        _categoryIcon = @"Parking.png";
    }
    return self;
}

@end
