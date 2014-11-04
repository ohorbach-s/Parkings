//
//  Category.m
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 10/28/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "PlaceCategories.h"

@implementation PlaceCategories : NSObject

+ (id)sharedManager
{
    static PlaceCategories *sharedMapManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMapManager = [[PlaceCategories alloc] init];
        
    });
    
    return sharedMapManager;
}
- (id)init
{
    if (self = [super init]) {
        _markersImages = @[@"Parking.png", @"BicycleShop.png",@"Cafe.png",@"Supermarket.png"];
        _categoryNamesArray = @[ @"Parking", @"BicycleShop", @"Cafe", @"Supermarket"];
//        _categoryNamesArray = @[NSLocalizedString(@"Parking", nil),
//                                NSLocalizedString(@"BicycleShop", nil),
//                                NSLocalizedString(@"Cafe", nil),
//                                NSLocalizedString(@"Supermarket", nil)];
    }
    return self;
}

@end
