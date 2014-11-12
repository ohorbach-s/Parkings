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
         _categoryNamesArray = @[ @"Parking", @"BicycleShop", @"Cafe", @"Supermarket"];
        _markersImages = @[@"Parking.png", @"BicycleShop.png",@"Cafe.png",@"Supermarket.png"];
        _markersSmallImages = @[@"parking_small.png", @"bicycleShop_small.png", @"cafe_small.png", @"supermarket_small.png"];
        _dotSmallImages = @[@"blue_dot.png", @"green_dot.png", @"orange_dot.png", @"purple_dot.png"];
        _dotMediumImages = @[@"blue_dot2.png",@"green_dot2.png", @"orange_dot2.png", @"purple_dot2.png"];
        _dotLargeImages = @[@"blue_dot3.png",@"green_dot3.png", @"orange_dot3.png", @"purple_dot3.png"];
    }
    return self;
}

@end
