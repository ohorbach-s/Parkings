//
//  StorageClass.m
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 10/28/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import "StorageClass.h"

@implementation StorageClass

+ (id)sharedManager {
    static StorageClass *sharedMapManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMapManager = [[StorageClass alloc] init];
        
    });
    
    return sharedMapManager;
}
- (id)init {
    
    if (self = [super init]) {
        _markersImages = @[@"parking.png", @"tools.png",@"cafe.png",@"supermarket.png"];
        _pickerData = @[@"Парковки", @"Сервіси/Магазини", @"Кафе", @"Супермаркети"];
        _pickerData2 = @[@"Parking", @"BicycleShop", @"Cafe", @"Supermarket"];
        _detailInfoForObject = [[DetailInfoClass alloc] init];
    }
    return self;
}


@end
