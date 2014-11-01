//
//  Category.h
//  LvivBicycleGuideApp
//
//  Created by Yuliia on 10/28/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailInfoClass.h"


@interface PlaceCategory : NSObject

@property(nonatomic, strong)NSArray *markersImages;
@property(nonatomic, strong)NSArray *categoryNamesArray;
//@property (nonatomic,strong)DetailInfoClass *detailInfoForObject;


+ (id)sharedManager;
@end
