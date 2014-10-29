//
//  StorageClass.h
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 10/28/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailInfoClass.h"
@interface StorageClass : NSObject

@property(nonatomic, strong)NSArray *markersImages;
@property(nonatomic, strong)NSArray *pickerData;
@property(nonatomic, strong)NSArray *pickerData2;
@property (nonatomic,strong)DetailInfoClass *detailInfoForObject;
+ (id)sharedManager;
@end
